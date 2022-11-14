import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/utils/current_year.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class YearPickerCupertino extends StatefulWidget {
  final bool isReverse;
  final Function onItemSelectedChanged;

  const YearPickerCupertino(
      {Key? key, required this.isReverse, required this.onItemSelectedChanged})
      : super(key: key);

  @override
  State<YearPickerCupertino> createState() => _YearPickerCupertinoState();
}

class _YearPickerCupertinoState extends State<YearPickerCupertino> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    int currentYear = getCurrentYear();
    int yearFrom = int.parse(dotenv.env['YEAR_FROM']!);
    int numberOfYears = currentYear - yearFrom + 1;
    List<int> years =
        List.generate(numberOfYears, (index) => (1990 + index)).toList();

    if (widget.isReverse) {
      years = years.reversed.toList();
    }

    return CupertinoActionSheet(
        title: Text('Selecciona una fecha',
            style: Theme.of(context).textTheme.headline6),
        actions: [
          SizedBox(
              height: 250,
              child: CupertinoPicker(
                itemExtent: 64,
                onSelectedItemChanged: (int index) =>
                    widget.onItemSelectedChanged(years[index]),
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
