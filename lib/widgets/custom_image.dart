import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:vims/constants/ui/assets.dart';

class CustomImage extends StatelessWidget {
  final String url;

  final bool saveToCache;
  final CacheManager cacheManager;
  final String? cacheKey;
  final double borderRadius;

  const CustomImage(
      {required this.url,
      required this.saveToCache,
      required this.cacheManager,
      this.cacheKey,
      this.borderRadius = 0,
      super.key});

  @override
  Widget build(BuildContext context) {
    return saveToCache
        ? ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: CachedNetworkImage(
              cacheKey: cacheKey ?? url,
              errorWidget: (context, url, error) => const _ErrorImage(),
              imageUrl: url,
              cacheManager: cacheManager,
              fit: BoxFit.cover,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: FadeInImage(
                placeholder: const AssetImage(Assets.SPINNER),
                image: NetworkImage(url),
                fit: BoxFit.cover,
                imageErrorBuilder: (_, __, ___) => const _ErrorImage()),
          );
  }
}

class _ErrorImage extends StatelessWidget {
  const _ErrorImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.NO_IMAGE,
      fit: BoxFit.cover,
    );
  }
}
