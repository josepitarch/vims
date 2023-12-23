import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteAllBookmarksDialog extends StatelessWidget {
  const DeleteAllBookmarksDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    return AlertDialog.adaptive(
      elevation: 0,
      content: Text(i18n.delete_all_bookmarks,
          style: Theme.of(context).textTheme.bodyLarge),
      actions: [
        TextButton(
          child: Text(
            i18n.cancel,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: Text(
            i18n.delete,
            style: const TextStyle(color: Colors.red),
          ),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
