import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_test_project/models/favourite_pokemon.dart';
import 'package:pokedex_test_project/models/pokemon.dart';
import 'package:pokedex_test_project/project_data/project_data.dart';
import 'package:pokedex_test_project/statics_and_constants/statics.dart';
import 'package:pokedex_test_project/statics_and_constants/constants.dart';
import 'package:pokedex_test_project/widgets/individual_stat.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonDetailsScreen extends StatefulWidget {
  final Pokemon pokemon;
  final String pokemonUrl;

  const PokemonDetailsScreen({
    Key? key,
    required this.pokemon,
    required this.pokemonUrl,
  }) : super(key: key);

  @override
  State<PokemonDetailsScreen> createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  bool addedToFavourites = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String bmiCalculator() {
    double bmi = (widget.pokemon.weight /
        (widget.pokemon.height * widget.pokemon.height));
    return bmi.toStringAsFixed(1);
  }

  int avgPower() {
    double averagePower = (widget.pokemon.pokemonStats.hp +
            widget.pokemon.pokemonStats.attack +
            widget.pokemon.pokemonStats.defense +
            widget.pokemon.pokemonStats.specialAttack +
            widget.pokemon.pokemonStats.specialDefense +
            widget.pokemon.pokemonStats.speed) /
        6;
    return averagePower.toInt();
  }

  bool isExistAtFavourites() {
     for(var u in Provider.of<ProjectData>(context, listen: true).favouritePokemonList) {
      if (u.id == widget.pokemon.id) {
        return true;
      }
    }
    return false;
  }

  Future<void> saveFavouritePokemonsToSharedPref(String data) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(favouritePokemonsList, data);
  }

  @override
  void didChangeDependencies() {
    addedToFavourites = isExistAtFavourites();
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.white,
            snap: true,
            floating: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                    color: pokemonBackgroundColor(
                        typesCount: widget.pokemon.types.length),
                    height: phoneWidth * 8 / 15,
                    child: Row(
                      children: [
                        SizedBox(
                          width: phoneWidth * 3 / 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18, top: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.pokemon.name.capitalize(),
                                          style: const TextStyle(
                                            fontSize: 38,
                                            fontWeight: FontWeight.bold,
                                            color: kTextBlackColor,
                                          ),
                                        ),
                                        Text(
                                          typesAsString(widget.pokemon.types),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: kTextBlackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 18, bottom: 18),
                                        child: Text(
                                          formattedPokemonIdStr(
                                              widget.pokemon.id),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: kTextBlackColor,
                                          ),
                                        ),
                                      ))),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: phoneWidth * 2 / 5,
                          child: Stack(
                            children: [
                              const Align(
                                alignment: Alignment.bottomRight,
                                child: Image(
                                    fit: BoxFit.scaleDown,
                                    height: 160,
                                    image: AssetImage('assets/vector.png')),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 18),
                                  child: CachedNetworkImage(
                                    height: phoneWidth / 3,
                                    imageUrl: widget.pokemon.imageUrl,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (index == 1) {
                  return SizedBox(
                    height: phoneWidth * 3 / 16 + 5,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18, right: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text('Height',
                                    style: kSmallDarkGrayTextStyle),
                              ),
                              Text('${widget.pokemon.height}',
                                  style: kSmallBlackTextStyle),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text('Weight',
                                    style: kSmallDarkGrayTextStyle),
                              ),
                              Text('${widget.pokemon.weight}',
                                  style: kSmallBlackTextStyle),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child:
                                    Text('BMI', style: kSmallDarkGrayTextStyle),
                              ),
                              Text(bmiCalculator(),
                                  style: kSmallBlackTextStyle),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (index == 2) {
                  return Column(
                    children: [
                      Container(
                        color: kBackgroundColor,
                        height: 8,
                      ),
                      const SizedBox(
                        height: 60,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 18),
                            child: Text(
                              'Base stats',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: kTextBlackColor),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: kBackgroundColor,
                        height: 2,
                      ),
                    ],
                  );
                } else if (index == 3) {
                  return IndividualStat(
                      statName: 'Hp',
                      statValue: widget.pokemon.pokemonStats.hp);
                } else if (index == 4) {
                  return IndividualStat(
                      statName: 'Attack',
                      statValue: widget.pokemon.pokemonStats.attack);
                } else if (index == 5) {
                  return IndividualStat(
                      statName: 'Defence',
                      statValue: widget.pokemon.pokemonStats.defense);
                } else if (index == 6) {
                  return IndividualStat(
                      statName: 'Special Attack',
                      statValue: widget.pokemon.pokemonStats.specialAttack);
                } else if (index == 7) {
                  return IndividualStat(
                      statName: 'Special Defence',
                      statValue: widget.pokemon.pokemonStats.specialDefense);
                } else if (index == 8) {
                  return IndividualStat(
                      statName: 'Speed',
                      statValue: widget.pokemon.pokemonStats.speed);
                } else if (index == 9) {
                  return IndividualStat(
                      statName: 'Avg. power', statValue: avgPower());
                }
              },
              childCount: 10,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        backgroundColor: addedToFavourites ? kButtonRemoveColor : kBlueColor,
        label: Center(
          child: addedToFavourites
              ? const Text(
                  'Remove from favourites',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kBlueColor,
                  ),
                )
              : const Text(
                  'Mark as favourite',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
        onPressed: () {
          setState(() {
            addedToFavourites = !addedToFavourites;

            if (addedToFavourites) {
              Provider.of<ProjectData>(context, listen: false).addToFavorites(
                  FavouritePokemon(widget.pokemon.id, widget.pokemonUrl));
            } else {
              Provider.of<ProjectData>(context, listen: false).deleteFromFavourites(widget.pokemon.id);
            }
            String jsonData = jsonEncode(Provider.of<ProjectData>(context, listen: false).favouritePokemonList);
            //print('==> json: ${jsonData}');
            saveFavouritePokemonsToSharedPref(jsonData);
          });
        },
      ),
    );
  }
}
