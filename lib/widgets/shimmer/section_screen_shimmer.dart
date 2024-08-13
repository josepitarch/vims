import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SectionShimmer extends StatelessWidget {
  final String title;
  final int total;

  const SectionShimmer({required this.title, this.total = 20, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        padding: const EdgeInsets.all(15),
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: List.generate(
            total,
            (index) => Shimmer.fromColors(
                  baseColor: Colors.black,
                  highlightColor: Colors.grey.shade100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                )));
  }
}
