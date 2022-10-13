import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/widgets/year_picker.dart';

class YearContainer extends StatelessWidget {
  final int year;
  const YearContainer({Key? key, required this.year}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: 90,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            //color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!)),
        child: InkWell(
          onTap: () => onTap(context, false),
          child: Center(
            child: Text(
              year.toString(),
            ),
          ),
        ));
  }

  void onTap(BuildContext context, bool isReverse) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return YearPickerCupertino(
              isReverse: isReverse,
              onItemSelectedChanged: (year) {
               
              });
        });
  }
}
