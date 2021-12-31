class Pokemon {
  final int id;
  final int height;
  final int weight;
  final String name;
  final List<String> types;
  final String imageUrl;
  final PokemonStats pokemonStats;

  Pokemon({
    required this.id,
    required this.height,
    required this.weight,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.pokemonStats,
  });
}


class PokemonStats {
  final int hp, attack, defense, specialAttack, specialDefense, speed;

  PokemonStats({
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
});

}
