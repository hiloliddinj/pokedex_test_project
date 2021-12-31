class Pokemons {
  final int count;
  final String? previous, next;
  List<Result> results;

  Pokemons(this.count, this.previous, this.next, this.results);

}

class Result {
  final String name, url;
  Result(this.name, this.url);
}