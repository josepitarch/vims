import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SectionsShimmer extends StatelessWidget {
  final int total;
  const SectionsShimmer({this.total = 5, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: List.generate(total, (index) => const SectionShimmer()),
      ),
    ));
  }
}

class SectionShimmer extends StatelessWidget {
  const SectionShimmer({
    Key? key,
  }) : super(key: key);

  final double width = 120;
  final double height = 190;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: 200,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            height: height - 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, __) => Container(
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
            ),
          ),
        ],
      ),
    );
  }
}
