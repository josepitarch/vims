import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vims/dialogs/year_picker_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class YearContainer extends StatelessWidget {
  final int year;
  final bool isReverse;
  final Function onPressed;
  final bool hasError;

  const YearContainer(
      {required this.year,
      required this.onPressed,
      required this.isReverse,
      this.hasError = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final String token = isReverse ? i18n.to_year : i18n.from_year;
    return MaterialButton(
        onPressed: () => openYearPicker(context),
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: hasError ? Colors.red : Colors.orange, width: 2),
            borderRadius: BorderRadius.circular(17)),
        child: Text('$token    $year',
            style: Theme.of(context).textTheme.bodyLarge));
  }

  void openYearPicker(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return YearPickerCupertino(
              isReverse: isReverse,
              onItemSelectedChanged: onPressed,
              selectedYear: year);
        });
  }
}
