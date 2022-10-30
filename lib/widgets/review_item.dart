import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';

class ReviewItem extends StatelessWidget {
  final Review review;
  const ReviewItem({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          review.body.replaceAll("\"", ''),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              review.author,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
            buildInclination(review.inclination)
          ],
        )
      ],
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
