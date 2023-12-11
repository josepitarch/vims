import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardActorShimmer extends StatelessWidget {
  final int total;
  const CardActorShimmer({this.total = 10, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: total,
        itemBuilder: (_, __) => Shimmer.fromColors(
              baseColor: Colors.black,
              highlightColor: Colors.grey.shade100,
              child: Container(
                margin: const EdgeInsets.all(10.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(30)),
                        height: 60,
                        width: 60,
                      ),
                      const SizedBox(width: 10),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10)),
                          height: 20,
                          width: 180,
                        ),
                      )
                    ]),
              ),
            ));
  }
}
