import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vims/models/enums/inclination.dart';

class ReviewItem extends StatelessWidget {
  final String content;
  final String author;
  final DateTime? createdAt;
  final Inclination inclination;

  const ReviewItem(
      {required this.content,
      required this.author,
      this.createdAt,
      required this.inclination,
      super.key});

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
          _Header(createdAt: createdAt),
          _Body(content: content),
          const SizedBox(height: 15),
          _Footer(inclination: inclination, author: author),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final DateTime? createdAt;

  const _Header({this.createdAt});

  @override
  Widget build(BuildContext context) {
    if (createdAt == null) {
      return const SizedBox.shrink();
    }
    final date =
        createdAt != null ? DateFormat('dd/MM/yyyy').format(createdAt!) : '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          date,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;
  const _Body({required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

class _Footer extends StatelessWidget {
  final Inclination inclination;
  final String author;
  const _Footer({required this.inclination, required this.author});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Inclination(inclination),
        Text(
          author,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }
}

class _Inclination extends StatelessWidget {
  final Inclination inclination;
  const _Inclination(this.inclination);

  @override
  Widget build(BuildContext context) {
    Map inclinationColors = {
      Inclination.POSITIVE: Colors.green,
      Inclination.NEUTRAL: Colors.yellow,
      Inclination.NEGATIVE: Colors.red,
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
