import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/utils/current_year.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class YearPickerCupertino extends StatelessWidget {
  final bool isReverse;
  final Function onItemSelectedChanged;
  final int selectedYear;

  const YearPickerCupertino(
      {Key? key,
      required this.isReverse,
      required this.onItemSelectedChanged,
      required this.selectedYear})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentYear = getCurrentYear();
    int yearFrom = int.parse(dotenv.env['YEAR_FROM']!);
    int numberOfYears = currentYear - yearFrom + 1;
    List<int> years =
        List.generate(numberOfYears, (index) => (1990 + index)).toList();

    if (isReverse) {
      years = years.reversed.toList();
    }

    return CupertinoActionSheet(
        title: Text('Selecciona una fecha',
            style: Theme.of(context).textTheme.headline6),
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
                  background: Colors.orange.withOpacity(0.6),
                ),
                children: years
                    .map((value) => Center(child: Text(value.toString())))
                    .toList(),
              ))
        ]);
  }
}
