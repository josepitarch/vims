import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io' as io show Platform;

class YearPickerCupertino extends StatelessWidget {
  final bool isReverse;
  final Function onItemSelectedChanged;
  final int selectedYear;

  const YearPickerCupertino(
      {required this.isReverse,
      required this.onItemSelectedChanged,
      required this.selectedYear,
      super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations i18n = AppLocalizations.of(context)!;
    final int currentYear = DateTime.now().year;
    final int yearFrom = int.parse(dotenv.env['YEAR_FROM']!);
    final int numberOfYears = currentYear - yearFrom + 1;
    List<int> years =
        List.generate(numberOfYears, (index) => (1990 + index)).toList();

    if (isReverse) {
      years = years.reversed.toList();
    }

    return CupertinoActionSheet(
        title: io.Platform.isIOS
            ? Text(i18n.select_year,
                style: Theme.of(context).textTheme.titleLarge)
            : null,
        actions: [
          SizedBox(
              height: 250,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                    initialItem: years.indexOf(selectedYear)),
                itemExtent: 64,
                onSelectedItemChanged: (int index) =>
                    onItemSelectedChanged(years[index]),
                selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                  background: io.Platform.isAndroid
                      ? Colors.orange.withOpacity(0.6)
                      : Colors.transparent,
                ),
                children: years
                    .map((value) => Center(child: Text(value.toString())))
                    .toList(),
              ))
        ]);
  }
}
