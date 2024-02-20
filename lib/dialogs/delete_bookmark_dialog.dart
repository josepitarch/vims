import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteBookmarkDialog extends StatelessWidget {
  final String userId;
  final int movieId;
  const DeleteBookmarkDialog(
      {required this.userId, required this.movieId, super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    return AlertDialog.adaptive(
      elevation: 0,
      title: Text(i18n.delete_bookmark_title_dialog),
      content: Text(i18n.delete_bookmark_content_dialog),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(i18n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(i18n.delete),
        ),
      ],
    );
  }
}
