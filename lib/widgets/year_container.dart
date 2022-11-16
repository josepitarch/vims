import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/dialogs/year_picker_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class YearContainer extends StatelessWidget {
  final int year;
  final bool isReverse;
  final Function onPressed;
  const YearContainer(
      {Key? key,
      required this.year,
      required this.onPressed,
      required this.isReverse})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    return MaterialButton(
        onPressed: () => openYearPicker(context),
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.orange, width: 2),
            borderRadius: BorderRadius.circular(5)),
        child: Wrap(
          spacing: 15,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(!isReverse ? i18n.from_year : i18n.to_year,
                style: Theme.of(context).textTheme.bodyText1),
            Text(year.toString()),
          ],
        ));
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
