import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrapper_filmaffinity/widgets/material_design_icons.dart';

class NoResults extends StatelessWidget {
  const NoResults({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    return Expanded(
      child: Container(
        transform: Matrix4.translationValues(0, -50, 0),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(MaterialDesignIcons.emoticonConfusedOutline,
                size: 100, color: Colors.white),
            const SizedBox(height: 20),
            Text(i18n.no_results, style: Theme.of(context).textTheme.headline6),
          ],
        ),
      ),
    );
  }
}
