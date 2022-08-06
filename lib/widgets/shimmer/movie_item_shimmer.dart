import 'package:flutter/material.dart';

class MovieItemShimmer extends StatelessWidget {
  const MovieItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 170.0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            height: height,
            width: 120,
            color: Colors.grey[300],
          ),
        ),
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(left: 10, top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 20,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                ],
              )),
        ),
      ]),
    );
  }
}
