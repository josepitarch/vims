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
      title: const Text('Mensaje de confirmación'),
      content: const Text(
          '¿Estás seguro de que quieres borrar todos los marcadores?'),
      actions: <TextButton>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.subtitle2,
          ),
          child: const Text('Cancelar'),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Eliminar'),
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
      title: const Text('Mensaje de confirmación'),
      content: const Text(
          '¿Estás seguro de que quieres borrar todos los marcadores?'),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
