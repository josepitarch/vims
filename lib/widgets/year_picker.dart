import 'package:flutter/cupertino.dart';
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

    return CupertinoActionSheet(actions: [
      SizedBox(
          height: 350,
          child: CupertinoPicker(
              itemExtent: 50,
              onSelectedItemChanged: (index) =>
                  widget.onItemSelectedChanged(years[index]),
              children: years
                  .map((year) => Text(
                        year.toString(),
                      ))
                  .toList()))
    ]);
  }
}
