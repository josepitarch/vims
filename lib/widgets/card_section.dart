import 'package:flutter/material.dart';
import 'package:vims/models/section.dart';
import 'package:vims/utils/custom_cache_manager.dart';
import 'package:vims/widgets/custom_image.dart';

class CardSection extends StatelessWidget {
  final MovieSection movie;
  final String heroTag;
  final bool saveToCache;

  const CardSection(
      {required this.movie,
      required this.heroTag,
      this.saveToCache = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    onTap() {
      final Map<String, dynamic> arguments = {
        'id': movie.id,
        'heroTag': heroTag
      };
      Navigator.pushNamed(context, 'movie', arguments: arguments);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.34,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: CustomImage(
                      url: movie.poster.mmed,
                      saveToCache: saveToCache,
                      borderRadius: 20,
                      cacheManager: CustomCacheManager.cacheTinyImages),
                ),
                _PremiereDay(movie.premiereDay),
              ],
            ),
            const SizedBox(height: 5),
            _Title(movie.title)
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class _PremiereDay extends StatelessWidget {
  final String premiereDay;

  const _PremiereDay(this.premiereDay);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
        height: width <= 414 ? 37 : 45,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.8),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              premiereDay,
              style: Theme.of(context).textTheme.bodyMedium,
            )));
  }
}
