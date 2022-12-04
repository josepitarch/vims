enum Flags {
  spain(['spain', 'espana']),
  portugal(['portugal']),
  eeuu(['estados unidos', 'united states']),
  france(['francia', 'france']),
  switzerland(['suiza', 'switzerland']),
  sween(['suecia', 'sweden']),
  uk(['reino unido', 'united kingdom']),
  ireland(['irlanda', 'ireland']),
  denmark(['dinamarca', 'denmark']),
  newZealand(['nueva zelanda', 'new zealand']),
  italy(['italia', 'italy']),
  germany(['alemania', 'germany']),
  hungary(['hungria', 'hungary']),
  turkey(['turquia', 'turkey']),
  argentina(['argentina', 'argentina']),
  mexico(['mexico']),
  brazil(['brasil', 'brazil']),
  russia(['rusia', 'russia']),
  china(['china']),
  japan(['japon', 'japan']),
  southKorea(['corea del sur', 'south korea']);

  const Flags(this._value);
  final List<String> _value;
  List<String> get value => _value;
}
