import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({Key? key, required this.title}) : super(key: key);

  final String title;

  static const Map<String, String> titleSectionsMapper = {
    'Cartelera España': 'Cartelera',
    'Próximos estrenos España': 'Próximos estrenos',
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
      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: Text(
        titleSectionsMapper[title] ?? title,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
