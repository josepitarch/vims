import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MovieFriendsShimmer extends StatelessWidget {
  const MovieFriendsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.grey.shade100,
      child: SizedBox(
        height: width <= 514 ? height * 0.23 : height * 0.26,
        child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, __) => AspectRatio(
            aspectRatio: 3 / 4,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
