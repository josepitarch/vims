import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/dialogs/year_picker_dialog.dart';

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
    return MaterialButton(
        onPressed: () => openYearPicker(context),
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.orange, width: 2),
            borderRadius: BorderRadius.circular(5)),
        child: Wrap(
          spacing: 15,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(!isReverse ? 'Desde' : 'Hasta',
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
