import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SectionsShimmer extends StatelessWidget {
  final int total;
  const SectionsShimmer({this.total = 5, super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView(
      children: List.generate(total, (index) => const SectionShimmer()),
    ));
  }
}

class SectionShimmer extends StatelessWidget {
  const SectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
              height: width <= 414 ? 25 : 30,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(width <= 414 ? 10.0 : 15.0),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            height: MediaQuery.of(context).size.height * 0.2,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, __) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width * 0.29,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
