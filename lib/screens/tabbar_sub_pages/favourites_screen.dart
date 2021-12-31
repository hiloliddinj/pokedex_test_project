import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pokedex_test_project/project_data/project_data.dart';
import 'package:pokedex_test_project/statics_and_constants/constants.dart';
import 'package:pokedex_test_project/widgets/pokemon_card.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      color: kBackgroundColor,
      child: StaggeredGridView.countBuilder(
          itemCount: Provider.of<ProjectData>(context, listen: true)
              .favouritePokemonList
              .length,
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          itemBuilder: (context, index) {
            return PokemonCard(
              pokemonUrl: Provider.of<ProjectData>(context, listen: true)
                  .favouritePokemonList[index]
                  .link,
            );
          },
          staggeredTileBuilder: (index) {
            return const StaggeredTile.count(1, 1.7);
          }),
    );
  }
}
