import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SeeMoreShimmer extends StatelessWidget {
  final int total;
  final double height;
  final double width;
  const SeeMoreShimmer(
      {required this.height, required this.width, this.total = 20, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1,
            mainAxisSpacing: 10,
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
      ),
    );
  }
}
