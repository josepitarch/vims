import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  final dynamic rating;

  const Rating(
    this.rating, {
    Key? key,
  }) : super(key: key);

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
        rating != null ? '${double.parse(rating.toString())}' : '---',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    ]);
  }
}
