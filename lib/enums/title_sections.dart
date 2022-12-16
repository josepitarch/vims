enum TitleSectionEnum {
  th(['Cartelera', 'Now in theaters']),
  coming_theaters(['Próximamente en cines', 'Coming soon to theaters']),
  netflix(['Netflix']),
  disney(['Disney+']),
  movistar(['Movistar+']),
  prime(['Amazon Prime']),
  hbo(['HBO Max']),
  filmin(['Filmin']),
  apple(['Apple TV+']);

  const TitleSectionEnum(this._value);
  final List<String> _value;
  List<String> get value => _value;
}