enum Genres {
  action('action'),
  adventure('adventure'),
  comedy('comedy'),
  drama('drama'),
  terror('terror'),
  musical('musical'),
  romance('romance'),
  war('war'),
  thriller('thriller'),
  mystery('mystery'),
  western('western'),
  kids('kids');

  const Genres(this._value);
  final String _value;
  String get value => _value;

  String search(String name) => _value;

  static getGenre(String name, String language) {
    return Genres.values
        .firstWhere((element) => element.search(language) == name);
  }
}
