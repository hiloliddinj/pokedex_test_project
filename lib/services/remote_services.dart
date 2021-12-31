import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex_test_project/models/pokemon.dart';
import 'package:pokedex_test_project/models/pokemons.dart';

Future fetchPokemonsByPagination(String url) async {
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);
    //print(jsonData);

    int count = jsonData['count'];
    String? previous = jsonData['previous'];
    String? next = jsonData['next'];
    List<Result> results = [];

    for (var u in jsonData['results']) {
      Result result = Result(u['name'], u['url']);
      results.add(result);
    }

    Pokemons pokemons = Pokemons(count, previous, next, results);

    return pokemons;
  } else {
    //debugPrint('Error in fetching Pokemons');
    return null;
  }
}

Future fetchPokemonDetails(String pokemonUrl) async {
  var response = await http.get(Uri.parse(pokemonUrl));

  if (response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);

    List<String> typesList = [];
    for (var a in jsonData['types']) {
      String type = a['type']['name'];
      typesList.add(type);
    }

    List stats = jsonData['stats'];
    int hp = 0,
        attack = 0,
        defense = 0,
        specialAttack = 0,
        specialDefense = 0,
        speed = 0;

    for (var index = 0; index < stats.length; index++) {
      switch (stats[index]['stat']['name']) {
        case 'hp':
          hp = stats[index]['base_stat'];
          break;
        case 'attack':
          attack = stats[index]['base_stat'];
          break;
        case 'defense':
          defense = stats[index]['base_stat'];
          break;
        case 'special-attack':
          specialAttack = stats[index]['base_stat'];
          break;
        case 'special-defense':
          specialDefense = stats[index]['base_stat'];
          break;
        case 'speed':
          speed = stats[index]['base_stat'];
          break;
      }
    }

    PokemonStats pokemonStats = PokemonStats(
        hp: hp,
        attack: attack,
        defense: defense,
        specialAttack: specialAttack,
        specialDefense: specialDefense,
        speed: speed);

    Pokemon pokemon = Pokemon(
      id: jsonData['id'],
      height: jsonData['height'],
      weight: jsonData['weight'],
      name: jsonData['name'],
      types: typesList,
      imageUrl: jsonData['sprites']['other']['official-artwork']
          ['front_default'],
      pokemonStats: pokemonStats,
    );
    return pokemon;
  } else {
    //debugPrint('Error Fetching Pokemon Data!');
    return null;
  }
}
