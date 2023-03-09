import 'package:collection/collection.dart';

enum TitleSectionEnum {
  th(['Cartelera', 'Now in theaters']),
  coming_theaters(['Próximamente en cines', 'Coming soon to theaters']),
  netflix(['Netflix']),
  sky_show_time(['SkyShowTime']),
  disney(['Disney+']),
  movistar(['Movistar+']),
  prime(['Amazon Prime']),
  hbo(['HBO Max']),
  filmin(['Filmin']),
  apple(['Apple TV+']);

  const TitleSectionEnum(this._value);
  final List<String> _value;
  List<String> get value => _value;

  static String getName(String title) {
    return TitleSectionEnum.values
            .firstWhereOrNull((element) => element.value.contains(title))
            ?.name ??
        '';
  }
}
