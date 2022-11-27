enum Platforms {
  netflix('netflix'),
  prime('prime'),
  hbo('hbo'),
  disney('disney'),
  movistar('movistar'),
  filmin('filmin'),
  rakuten('rakuten'),
  apple('apple'),
  flixole('flixole'),
  acontra('acontra');

  const Platforms(this._value);
  final String _value;
  String get value => _value;
}
