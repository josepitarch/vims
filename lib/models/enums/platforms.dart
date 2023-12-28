enum Platforms {
  netflix(['netflix'], true),
  prime(['amazon video', 'amazon prime video'], true),
  hbo_max(['hbo max'], true),
  disney(['disney plus'], true),
  movistar(['movistar plus'], true),
  filmin(['filmin'], true),
  sky_show_time(['skyshowtime'], true),
  rakuten(['rakuten tv'], true),
  apple(['apple itunes', 'apple tv plus', 'apple tv'], true),
  flixole(['flixolé'], true),
  acontra(['acontra plus'], true),
  google(['google play movies'], false),
  microsoft(['microsoft store'], false),
  fubo(['fubotv'], false),
  netflix_ads(['netflix basic with ads'], false),
  chili(['chili'], false);

  const Platforms(this._value, this.showInTopFilters);
  final List<String> _value;
  final bool showInTopFilters;
  List<String> get value => _value;
}
