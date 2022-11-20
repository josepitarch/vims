import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:scrapper_filmaffinity/utils/custom_cache_manager.dart';

class CustomImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final bool saveToCache;
  final String? cacheKey;

  const CustomImage(
      {Key? key,
      required this.url,
      required this.width,
      required this.height,
      required this.saveToCache,
      this.cacheKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return saveToCache
        ? CachedNetworkImage(
            cacheKey: cacheKey ?? url,
            placeholder: (context, url) => const AspectRatio(
              aspectRatio: 1.6,
              child: BlurHash(hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
            ),
            imageUrl: url,
            width: width,
            height: height,
            cacheManager: CustomCacheManager.cacheImages,
            fit: BoxFit.cover,
          )
        : FadeInImage(
            placeholder: const AssetImage('assets/loading.gif'),
            image: NetworkImage(url),
            width: width,
            height: height,
            fit: BoxFit.cover,
            imageErrorBuilder: (_, __, ___) => Image.asset(
                'assets/no-image.jpg',
                height: height + 30,
                fit: BoxFit.cover,
                width: width));
  }
}
