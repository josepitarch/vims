import 'package:flutter/material.dart';
import 'package:vims/models/section.dart';
import 'package:vims/widgets/card_section.dart';

class SectionWidget extends StatelessWidget {
  final Section section;

  const SectionWidget({required this.section, super.key});

  @override
  Widget build(BuildContext context) {
    final Map arguments = {
      'title': section.title,
      'id': section.id,
    };

    onTap() => Navigator.pushNamed(context, 'section', arguments: arguments);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: onTap,
            child: _HeadlineSection(icon: section.icon, title: section.title),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.29,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 12),
              ...section.movies.map((movie) => CardSection(
                    movieSection: movie,
                    heroTag: "${movie.id}${section.title}",
                    saveToCache: true,
                  ))
            ],
          ),
        )
      ],
    );
  }
}

class _HeadlineSection extends StatelessWidget {
  const _HeadlineSection({
    required this.icon,
    required this.title,
  });

  final String? icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) _IconSection(icon: icon!, title: title),
        const SizedBox(width: 7),
        Text(title,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.displayMedium!),
        const SizedBox(width: 5),
        Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Colors.white.withOpacity(.5),
        )
      ],
    );
  }
}

class _IconSection extends StatelessWidget {
  const _IconSection({
    required this.icon,
    required this.title,
  });

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Image.network(icon,
            height: width <= 414 ? 25 : 35,
            semanticLabel: "Icono de $title",
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink()));
  }
}
