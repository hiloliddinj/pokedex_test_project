import 'package:pokedex_test_project/statics_and_constants/constants.dart';

class FavouritePokemon {
  int id;
  String link;

  FavouritePokemon(this.id, this.link);

  Map<String, dynamic> toJson() => {
    idStr: id,
    linkStr: link,
  };
}