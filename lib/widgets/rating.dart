import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  final double? rating;

  const Rating(this.rating, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Icon(
        Icons.star,
        color: Colors.yellow,
        size: 30,
      ),
      const SizedBox(
        width: 7,
      ),
      Text(
        rating?.toString() ?? '---',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    ]);
  }
}
