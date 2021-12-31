import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_test_project/models/pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokedex_test_project/screens/pokemon_details_screen.dart';
import 'package:pokedex_test_project/services/remote_services.dart';
import 'package:pokedex_test_project/statics_and_constants/constants.dart';
import 'package:pokedex_test_project/statics_and_constants/statics.dart';

class PokemonCard extends StatefulWidget {
  final String pokemonUrl;

  const PokemonCard({
    required this.pokemonUrl,
    Key? key,
  }) : super(key: key);

  @override
  _PokemonCardState createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  bool _isPokemonLoading = true;

  Pokemon? _pokemon;

  getPokemonDetails() async {
    _pokemon = await fetchPokemonDetails(widget.pokemonUrl);
    if (_pokemon != null) {
      setState(() {
        _isPokemonLoading = false;
      });
    } else {
      //print('Internet Connection Error!');
    }
  }

  @override
  void initState() {
    getPokemonDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isPokemonLoading) {
      return const Center(
        child: CupertinoActivityIndicator(radius: 20),
      );
    } else {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PokemonDetailsScreen(pokemon: _pokemon!, pokemonUrl: widget.pokemonUrl,)),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              color: Colors.white),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    color: pokemonBackgroundColor(
                        typesCount: _pokemon!.types.length),
                    child: CachedNetworkImage(
                      imageUrl: _pokemon!.imageUrl,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedPokemonIdStr(_pokemon!.id),
                                style: const TextStyle(
                                  color: kTextDarkGrayColor,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                _pokemon!.name.capitalize(),
                                style: const TextStyle(
                                  color: kTextBlackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            typesAsString(_pokemon!.types),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              color: kTextDarkGrayColor,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      );
    }
  }
}
