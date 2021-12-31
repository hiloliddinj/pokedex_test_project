import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pokedex_test_project/models/pokemons.dart';
import 'package:pokedex_test_project/services/remote_services.dart';
import 'package:pokedex_test_project/widgets/pokemon_card.dart';
import 'package:pokedex_test_project/statics_and_constants/constants.dart';

class AllPokemonsScreen extends StatefulWidget {
  const AllPokemonsScreen({Key? key}) : super(key: key);

  @override
  State<AllPokemonsScreen> createState() => _AllPokemonsScreenState();
}

class _AllPokemonsScreenState extends State<AllPokemonsScreen> {
  var isPokemonsLoadong = false;
  List<Result> pokemonsList = [];
  int maxNumberOfPokemons = 0;

  var nextLink = '';

  void getPokemons(bool isFirstTime) async {
    String firstTimeUrl = 'https://pokeapi.co/api/v2/pokemon';
    if (isFirstTime) {

      isPokemonsLoadong = true;
        Pokemons? pokemons =
            await fetchPokemonsByPagination(firstTimeUrl);
        if (pokemons != null) {
          pokemonsList = pokemons.results;
          if (pokemons.next != null || pokemons.next!.isNotEmpty) {
            nextLink = pokemons.next!;
          } else {
            nextLink = '';
          }
        } else {

          _showConnectionErrorDialog();
        }
        setState(() {
          isPokemonsLoadong = false;
        });

    } else {
      if (nextLink.isNotEmpty) {

          isPokemonsLoadong = true;
          Pokemons? nextPokemons =
              await fetchPokemonsByPagination(nextLink);
          if (nextPokemons != null) {
            if (nextPokemons.next != null || nextPokemons.next!.isNotEmpty) {
              nextLink = nextPokemons.next!;
              pokemonsList.addAll(nextPokemons.results);
            } else {
              nextLink = '';
            }
          } else {
            //TODO
            _showConnectionErrorDialog();
          }

          setState(() {
            isPokemonsLoadong = false;
          });

      }
    }
  }

  Future<void> _showConnectionErrorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Server Communication Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Pokemons were not able to fetch'),
                Text('Please check your internet connection'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getPokemons(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isPokemonsLoadong) {
      return const Center(child: CupertinoActivityIndicator(radius: 20));
    } else {
      return Container(
        padding: const EdgeInsets.all(15),
        color: kBackgroundColor,
        child: StaggeredGridView.countBuilder(
            itemCount: pokemonsList.length + 1,
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemBuilder: (context, index) {
              if (index == pokemonsList.length) {
                if (nextLink != '') {
                  return InkWell(
                    onTap: () {
                      getPokemons(false);
                    },
                    child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                            color: Colors.white),
                        child: const Center(child: Text('Load More...'))),
                  );
                }
              }
              return PokemonCard(
                pokemonUrl: pokemonsList[index].url,
              );
            },
            staggeredTileBuilder: (index) {
              return const StaggeredTile.count(1, 1.7);
            }),
      );
    }
  }
}
