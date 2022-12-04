import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/models/section.dart';
import 'package:scrapper_filmaffinity/utils/custom_cache_manager.dart';
import 'package:scrapper_filmaffinity/widgets/custom_image.dart';
import 'package:scrapper_filmaffinity/widgets/title_section.dart';

class SectionWidget extends StatelessWidget {
  final Section section;

  const SectionWidget({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TitleSection(section.title),
        ),
        SizedBox(
          height: 210,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 12),
              ...section.movies
                  .map((movie) =>
                      _SectionMovie(film: movie, sectionTitle: section.title))
                  .toList(),
            ],
          ),
        )
      ],
    );
  }
}

class _SectionMovie extends StatelessWidget {
  final MovieSection film;
  final String sectionTitle;

  const _SectionMovie(
      {Key? key, required this.film, required this.sectionTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double width = 120;
    const double height = 190;
    final String heroTag = film.id + sectionTitle;

    return GestureDetector(
      onTap: () {
        Map<String, dynamic> arguments = {'id': film.id, 'heroTag': heroTag};
        Navigator.pushNamed(context, 'details', arguments: arguments);
      },
      child: Container(
          margin: const EdgeInsets.only(right: 15),
          width: width,
          height: height,
          child: Column(children: [
            Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CustomImage(
                        url: film.image,
                        width: width,
                        height: height - 30,
                        saveToCache: true,
                        cacheManager: CustomCacheManager.cacheTinyImages),
                    Container(
                      height: 40,
                      width: double.infinity,
                      color: Colors.orange.withOpacity(0.8),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          film.premiereDay,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              film.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            )
          ])),
    );
  }
}
