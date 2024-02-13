import 'package:flutter/material.dart';

class UserReviewDialog extends StatelessWidget {
  const UserReviewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    String userInput = '';
    return AlertDialog(
      title: const Text('Diálogo con TextField'),
      contentPadding: const EdgeInsets.all(16.0),
      titlePadding: const EdgeInsets.all(16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              userInput = value;
            },
            decoration: const InputDecoration(labelText: 'Escribe algo'),
          ),
          const SizedBox(height: 16.0),
          Text('Texto ingresado: $userInput'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, userInput);
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
