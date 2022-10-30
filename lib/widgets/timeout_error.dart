import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/widgets/material_design_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeoutError extends StatelessWidget {
  final VoidCallback onPressed;
  const TimeoutError({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(MaterialDesignIcons.emoticonConfusedOutline,
            size: 100, color: Colors.white),
        const SizedBox(height: 20),
        Text(localization.timeout_error,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6),
        TextButton(
            onPressed: () => onPressed(), child: Text(localization.retry))
      ],
    ));
  }
}
