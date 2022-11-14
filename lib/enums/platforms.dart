enum Platforms {
  netflix('netflix'),
  amazon('amazon'),
  hbo('hbo'),
  disney('disney'),
  movistar('movistar'),
  filmin('filmin'),
  rakuten('rakuten'),
  flixole('flixole'),
  acontra('acontra');

  const Platforms(this._value);
  final String _value;
  String get value => _value;
}
