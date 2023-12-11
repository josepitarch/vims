import 'package:flutter/material.dart';
import 'package:vims/models/section.dart';
import 'package:vims/widgets/card_section.dart';

class SectionWidget extends StatelessWidget {
  final Section section;

  const SectionWidget({required this.section, super.key});

  @override
  Widget build(BuildContext context) {
    const double height = 220;
    final Map arguments = {
      'title': section.title,
      'id': section.id,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
          child: InkWell(
            onTap: () =>
                Navigator.pushNamed(context, 'see_more', arguments: arguments),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (section.icon != null)
                  ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Image.network(section.icon!, height: 25)),
                const SizedBox(width: 7),
                Text(section.title,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.displayMedium!
                    //.copyWith(fontFamily: 'Lato'),
                    ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.white.withOpacity(.5),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: height,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 12),
              ...section.movies.map((movie) => CardSection(
                  movieSection: movie,
                  heroTag: "${movie.id}${section.title}",
                  saveToCache: true,
                  height: height,
                  width: 120))
            ],
          ),
        )
      ],
    );
  }
}
