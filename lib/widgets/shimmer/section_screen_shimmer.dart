import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SectionShimmer extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final int total;
  const SectionShimmer(
      {required this.title,
      required this.height,
      required this.width,
      this.total = 20,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GridView.count(
          padding: const EdgeInsets.only(top: 15, left: 10),
          crossAxisCount: 3,
          childAspectRatio: 0.85,
          mainAxisSpacing: 15,
          children: List.generate(
              total,
              (index) => Shimmer.fromColors(
                    baseColor: Colors.black,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: width,
                          height: height,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ))),
    );
  }
}
