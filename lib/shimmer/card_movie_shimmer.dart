import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardMovieShimmer extends StatelessWidget {
  const CardMovieShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 170.0;
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.grey.shade100,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(25)),
              height: height,
              width: 120,
            ),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 10, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                        height: 20,
                        width: 180,
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                        height: 20,
                        width: 150,
                      ),
                    ],
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
