enum Genres {
  action({'en': 'Action', 'es': 'Acción'}),
  adventure({'en': 'Adventure', 'es': 'Aventura'}),
  comedy({'en': 'Comedy', 'es': 'Comedia'}),
  drama({'en': 'Drama', 'es': 'Drama'}),
  terror({'en': 'Terror', 'es': 'Terror'}),
  musical({'en': 'Music', 'es': 'Música'}),
  romance({'en': 'Romance', 'es': 'Romance'}),
  war({'en': 'War', 'es': 'Guerra'}),
  thriller({'en': 'Thriller', 'es': 'Thriller'}),
  mystery({'en': 'Mystery', 'es': 'Misterio'}),
  western({'en': 'Western', 'es': 'Western'}),
  kids({'en': 'Infantil', 'es': 'Infantil'});

  const Genres(this._value);
  final Map<String, String> _value;
  Map<String, String> get value => _value;
}
