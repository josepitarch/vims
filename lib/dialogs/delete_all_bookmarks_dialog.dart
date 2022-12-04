import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteAllBookmarksDialog extends StatelessWidget {
  final bool isAndroid;

  const DeleteAllBookmarksDialog({Key? key, required this.isAndroid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isAndroid ? const _DialogAndroid() : const _DialogIOS();
  }
}

class _DialogAndroid extends StatelessWidget {
  const _DialogAndroid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(i18n.title_bookmark_dialog),
      content: Text(i18n.delete_all_bookmarks),
      actions: <TextButton>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.subtitle2,
          ),
          child: Text(
            i18n.cancel,
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: Text(i18n.delete,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.red)),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}

class _DialogIOS extends StatelessWidget {
  const _DialogIOS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    return CupertinoAlertDialog(
      title: Text(i18n.title_bookmark_dialog),
      content: Text(i18n.title_bookmark_dialog),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, false),
          child: Text(i18n.cancel),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context, true),
          child: Text(i18n.delete),
        ),
      ],
    );
  }
}
