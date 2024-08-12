import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vims/models/section.dart';
import 'package:vims/utils/custom_cache_manager.dart';
import 'package:vims/widgets/custom_image.dart';

class CardSection extends StatelessWidget {
  final MovieSection movie;
  final bool saveToCache;

  const CardSection({required this.movie, this.saveToCache = false, super.key});

  @override
  Widget build(BuildContext context) {
    onTap() => context.push('/movie/${movie.id}');

    return InkWell(
      onTap: onTap,
      child: CustomImage(
          url: movie.poster.mmed,
          saveToCache: saveToCache,
          borderRadius: 20,
          cacheManager: CustomCacheManager.cacheTinyImages),
    );
  }
}
