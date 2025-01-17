import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vims/models/base_movie.dart';
import 'package:vims/utils/custom_cache_manager.dart';
import 'package:vims/widgets/custom_image.dart';

class CardSection extends StatelessWidget {
  final BaseMovie movie;
  final bool saveToCache;
  final double width;

  const CardSection(
      {required this.movie,
      this.saveToCache = false,
      this.width = 0.34,
      super.key});

  @override
  Widget build(BuildContext context) {
    onTap() => context.push('/movie/${movie.id}');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * width,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: CustomImage(
                  url: movie.poster.mmed,
                  saveToCache: saveToCache,
                  borderRadius: 20,
                  cacheManager: CustomCacheManager.cacheTinyImages),
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
