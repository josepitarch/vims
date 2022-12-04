import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final String title;
  const TitleSection(this.title, {Key? key}) : super(key: key);

  //TODO: enum
  static const Map<String, String> titleSectionsMapper = {
    'Cartelera España': 'Cartelera',
    'Próximos estrenos España': 'Próximamente en cines',
    'Netflix (estrenos destacados)': 'Netflix',
    'Disney+': 'Disney+',
    'Movistar Plus+': 'Movistar+',
    'HBO Max España': 'HBO Max',
    'Amazon Prime Video España': 'Amazon Prime',
    'Filmin (últ. incorporaciones)': 'Filmin',
    'Apple TV+ (estrenos destacados)': 'Apple TV+',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 15.0, bottom: 7.0),
      child: Text(
        titleSectionsMapper[title] ?? title,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}
