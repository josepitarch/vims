import 'package:flutter/material.dart';
import 'package:vims/widgets/flag.dart';

class Country extends StatelessWidget {
  final String country;
  final String flag;

  const Country({
    required this.country,
    this.flag = '',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flag(flag: flag, country: country),
        const SizedBox(
          width: 10,
        ),
        Text(
          country,
          style: Theme.of(context).textTheme.headlineSmall,
        )
      ],
    );
  }
}
