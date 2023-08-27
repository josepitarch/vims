import 'package:flutter/material.dart';
import 'package:vims/models/section.dart';
import 'package:vims/utils/custom_cache_manager.dart';
import 'package:vims/widgets/custom_image.dart';

class CardSection extends StatelessWidget {
  final MovieSection movieSection;
  final String heroTag;
  final bool saveToCache;
  final double height;
  final double width;

  const CardSection(
      {Key? key,
      required this.movieSection,
      required this.heroTag,
      this.saveToCache = false,
      this.height = 210,
      this.width = 120})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final Map<String, dynamic> arguments = {
          'id': movieSection.id,
          'heroTag': heroTag
        };
        Navigator.pushNamed(context, 'details', arguments: arguments);
      },
      child: Container(
          height: height,
          width: width,
          margin: const EdgeInsets.only(right: 15),
          child: Column(children: [
            Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CustomImage(
                        url: movieSection.poster.mmed,
                        width: width,
                        height: height - 50,
                        saveToCache: saveToCache,
                        cacheManager: CustomCacheManager.cacheTinyImages),
                    Container(
                      height: 37,
                      width: double.infinity,
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          movieSection.premiereDay,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              movieSection.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ])),
    );
  }
}
