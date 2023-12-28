import 'package:flutter/material.dart';
import 'package:vims/models/movie.dart';

class ReviewItem extends StatelessWidget {
  final Review review;
  const ReviewItem({required this.review, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 2), blurRadius: 2.0)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review.body.replaceAll("\"", ''),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildInclination(review.inclination),
              Text(
                review.author,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Container buildInclination(String inclination) {
    Map inclinationColors = {
      'positive': Colors.green,
      'negative': Colors.red,
      'neutral': Colors.yellow,
    };

    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: inclinationColors[inclination] ?? Colors.yellow,
        shape: BoxShape.circle,
      ),
    );
  }
}
