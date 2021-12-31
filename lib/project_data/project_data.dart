import 'package:flutter/cupertino.dart';
import 'package:pokedex_test_project/models/favourite_pokemon.dart';

class ProjectData extends ChangeNotifier {
  List<FavouritePokemon> favouritePokemonList = [];

  addToFavorites(FavouritePokemon favouritePokemon) {
    favouritePokemonList.add(favouritePokemon);
    notifyListeners();
  }

  deleteFromFavourites(int pokemonId) {
    for(var i=0; i<favouritePokemonList.length; i++) {
      if (pokemonId == favouritePokemonList[i].id) {
        favouritePokemonList.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }

  updateFromSharedPrefs(List<FavouritePokemon> list) {
    favouritePokemonList = list;
    notifyListeners();
  }
}