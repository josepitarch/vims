import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoResults extends StatelessWidget {
  const NoResults({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    return Flexible(
      flex: 8,
      child: Center(
        child:
            Text(i18n.no_results, style: Theme.of(context).textTheme.headline6),
      ),
    );
  }
}
