import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/widgets/title_page.dart';
import 'package:shimmer/shimmer.dart';

class SeeMoreShimmer extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final int total;
  const SeeMoreShimmer(
      {required this.title,
      required this.height,
      required this.width,
      this.total = 20,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitlePage(title),
              Expanded(
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
            ],
          ),
        ),
      ),
    );
  }
}
