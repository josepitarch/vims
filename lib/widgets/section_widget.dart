import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vims/models/section.dart';
import 'package:vims/widgets/section_movie.dart';

class SectionWidget extends StatelessWidget {
  final Section section;

  const SectionWidget({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(section.title,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline2!
                  //.copyWith(fontFamily: 'Lato'),
                  ),
              CupertinoButton(
                  child: Text(i18n.see_more,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontStyle: FontStyle.italic,
                          fontFamily: 'OpenSans',
                          color: Theme.of(context).colorScheme.secondary)),
                  onPressed: () => Navigator.pushNamed(context, 'see_more',
                      arguments: section.title))
            ],
          ),
        ),
        SizedBox(
          height: 210,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 12),
              ...section.movies
                  .map((movie) => SectionMovie(
                      movieSection: movie,
                      heroTag: movie.id + section.title,
                      saveToCache: true,
                      height: 190,
                      width: 120))
                  .toList(),
            ],
          ),
        )
      ],
    );
  }
}
