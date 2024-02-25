import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailVerifiedDialog extends StatelessWidget {
  const EmailVerifiedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    return AlertDialog.adaptive(
      elevation: 0,
      content: Text(i18n.email_verified_content_dialog),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(i18n.accept),
        ),
      ],
    );
  }
}
