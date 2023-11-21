import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final String title;
  const TitleSection(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0, bottom: 7.0),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}
