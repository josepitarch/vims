import 'package:flutter/material.dart';
import 'package:vims/models/movie.dart';
import 'package:vims/utils/custom_cache_manager.dart';
import 'package:vims/widgets/custom_image.dart';
import 'package:vims/widgets/justwatch_item.dart';
import 'package:vims/widgets/rating.dart';

class CardMovie extends StatelessWidget {
  final int id;
  final String? heroTag;
  final String title;
  final String poster;
  final String? director;
  final double? rating;
  final List<Platform> platforms;
  final bool saveToCache;

  const CardMovie({
    required this.id,
    this.heroTag,
    required this.title,
    required this.poster,
    this.director,
    this.rating,
    this.platforms = const [],
    required this.saveToCache,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    onTap() => Navigator.pushNamed(context, 'movie',
        arguments: {'id': id, 'heroTag': heroTag});

    return InkWell(
      onTap: onTap,
      child: Container(
        height: height * 0.2,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        margin: const EdgeInsets.only(bottom: 20.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Hero(
            tag: heroTag ?? id,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: _Poster(
                id: id,
                poster: poster,
                saveToCache: saveToCache,
              ),
            ),
          ),
          Expanded(
            child: Container(
                height: height,
                margin: const EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _Title(title),
                    const SizedBox(height: 10.0),
                    _Director(director),
                    const SizedBox(height: 10.0),
                    rating != null ? Rating(rating) : const SizedBox.shrink(),
                    const Expanded(child: SizedBox()),
                    _Platforms(platforms),
                  ],
                )),
          ),
          SizedBox(
              height: height,
              child: Icon(Icons.arrow_forward_ios_outlined,
                  size: width <= 414 ? 22 : 27, color: Colors.grey))
        ]),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  final int id;
  final String poster;
  final bool saveToCache;

  const _Poster({
    required this.id,
    required this.poster,
    required this.saveToCache,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: CustomImage(
          url: poster,
          saveToCache: saveToCache,
          cacheManager: CustomCacheManager.cacheTinyImages),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title(this.title);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Text(
        title,
        style: Theme.of(context).textTheme.displaySmall,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}

class _Director extends StatelessWidget {
  final String? director;

  const _Director(this.director);

  @override
  Widget build(BuildContext context) {
    if (director == null) return const SizedBox.shrink();

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Text(
        director!,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontStyle: FontStyle.italic,
              //color: Theme.of(context).colorScheme.secondary
            ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}

class _Platforms extends StatelessWidget {
  final List<Platform> platforms;
  const _Platforms(this.platforms);

  @override
  Widget build(BuildContext context) {
    const double height = 37.5;
    const double width = height;
    return SizedBox(
      height: height,
      child: ListView(
          scrollDirection: Axis.horizontal,
          reverse: false,
          children: platforms
              .map((platform) =>
                  JustwatchItem(platform, height: height, width: width))
              .toList()),
    );
  }
}
