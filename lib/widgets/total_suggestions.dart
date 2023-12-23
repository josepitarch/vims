import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TotalSuggestions extends StatelessWidget {
  int total;
  TotalSuggestions({this.total = 0, super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations i18n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Text('${i18n.total_results}: $total',
          style: Theme.of(context).textTheme.headlineMedium!),
    );
  }
}
