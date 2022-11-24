import 'package:flutter/material.dart';

enum SingingCharacter { lafayette, jefferson }

class OrderByDialog extends StatefulWidget {
  const OrderByDialog({super.key});

  @override
  State<OrderByDialog> createState() => _OrderByDialogState();
}

class _OrderByDialogState extends State<OrderByDialog> {
  @override
  Widget build(BuildContext context) {
    SingingCharacter? character = SingingCharacter.lafayette;
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Lafayette'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.lafayette,
            groupValue: character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                character = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Thomas Jefferson'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.jefferson,
            groupValue: character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                character = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
