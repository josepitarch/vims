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
          borderRadius: BorderRadius.circular(10), color: Colors.grey[800]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review.body.replaceAll("\"", ''),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                review.author,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
              buildInclination(review.inclination)
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
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: inclinationColors[inclination] ?? Colors.yellow,
        shape: BoxShape.circle,
      ),
    );
  }
}
