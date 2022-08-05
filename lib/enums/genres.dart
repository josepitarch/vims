enum Genres {
  action('Action'),
  adventure('Adventure'),
  animation('Animation'),
  comedy('Comedy'),
  crime('Crime'),
  documentary('Documentary'),
  drama('Drama'),
  family('Family'),
  fantasy('Fantasy'),
  history('History'),
  horror('Horror'),
  music('Music'),
  mystery('Mystery'),
  romance('Romance'),
  sciFi('Sci-Fi'),
  tvMovie('TV Movie'),
  thriller('Thriller'),
  war('War'),
  western('Western');

  const Genres(this._value);
  final String _value;
  String get value => _value;
}
