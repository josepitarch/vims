import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailNoVerifiedDialog extends StatelessWidget {
  const EmailNoVerifiedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    return AlertDialog.adaptive(
      elevation: 0,
      content: Text(i18n.email_not_verified_content_dialog),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(i18n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(i18n.verify_email),
        ),
      ],
    );
  }
}
