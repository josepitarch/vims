import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vims/widgets/material_design_icons.dart';

class NoResults extends StatelessWidget {
  const NoResults({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(MaterialDesignIcons.emoticonConfusedOutline,
              size: 100, color: Colors.white),
          const SizedBox(height: 20),
          Text(i18n.no_results, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
