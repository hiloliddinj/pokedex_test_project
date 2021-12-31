import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex_test_project/models/favourite_pokemon.dart';
import 'package:pokedex_test_project/project_data/project_data.dart';
import 'package:pokedex_test_project/screens/tabbar_sub_pages/all_pokemons_screen.dart';
import 'package:pokedex_test_project/screens/tabbar_sub_pages/favourites_screen.dart';
import 'package:pokedex_test_project/statics_and_constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({Key? key}) : super(key: key);

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _getFavouritePokemonsFromSharedPref() async {
    final SharedPreferences prefs = await _prefs;

    String jsonFavouritePokemonObjects = prefs.getString(favouritePokemonsList) ?? '';
    List<FavouritePokemon> list = [];
    if (jsonFavouritePokemonObjects.isNotEmpty && jsonFavouritePokemonObjects != '') {
      List jsonData = jsonDecode(jsonFavouritePokemonObjects);


      for (var favourite in jsonData) {
        list.add(FavouritePokemon(favourite[idStr], favourite[linkStr]));
      }
    }
    Provider.of<ProjectData>(context, listen: false).updateFromSharedPrefs(list);

  }

  @override
  void initState() {
    _getFavouritePokemonsFromSharedPref();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                      fit: BoxFit.scaleDown,
                      height: 30,
                      image: AssetImage('assets/pokemon.png')),
                  SizedBox(width: 10),
                  Text(
                    'Pokedex',
                    style: TextStyle(
                      color: kTextBlackColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                color: kBackgroundColor,
                height: 3,
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: kBlueColor,
          indicatorWeight: 5,
          unselectedLabelColor: Colors.green,
          tabs: [
            Tab(
                child: Center(
                    child: Text('All Pokemons',
                        style: TextStyle(
                          color: _selectedIndex == 0
                              ? kTextBlackColor
                              : kTextDarkGrayColor,
                          fontSize: 18,
                        )))),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Favourites',
                      style: TextStyle(
                        color: _selectedIndex == 1
                            ? kTextBlackColor
                            : kTextDarkGrayColor,
                        fontSize: 18,
                      )),
                  const SizedBox(width: 5),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                        color: kBlueColor, shape: BoxShape.circle),
                    child: Center(
                        child: Text(
                            Provider.of<ProjectData>(context, listen: true)
                                .favouritePokemonList
                                .length
                                .toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ))),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AllPokemonsScreen(),
          FavouritesScreen(),
        ],
      ),
    );
  }
}
