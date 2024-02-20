import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserReviewDialog extends StatelessWidget {
  const UserReviewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    String userInput = '';
    return SafeArea(
      child: AlertDialog(
        title: const Text('Escribe tu crítica'),
        contentPadding: const EdgeInsets.all(16.0),
        titlePadding: const EdgeInsets.all(16.0),
        content: SingleChildScrollView(
          child: TextField(
            onChanged: (value) {
              userInput = value;
            },
            maxLines: 15,
            maxLength: 500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(i18n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, userInput);
            },
            child: Text(i18n.publish),
          ),
        ],
      ),
    );
  }
}
