import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final bool saveToCache;
  final CacheManager cacheManager;
  final String? cacheKey;

  const CustomImage(
      {Key? key,
      required this.url,
      required this.width,
      required this.height,
      required this.saveToCache,
      required this.cacheManager,
      this.cacheKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return saveToCache
        ? CachedNetworkImage(
            cacheKey: cacheKey ?? url,
            errorWidget: (context, url, error) =>
                _ErrorImage(height: height, width: width),
            // placeholder: (context, url) =>
            //     const BlurHash(hash: 'LCC\$ZU%L0fM{%%W?IoWA0QIp\$fs+'),
            imageUrl: url,
            width: width,
            height: height,
            cacheManager: cacheManager,
            fit: BoxFit.cover,
          )
        : FadeInImage(
            placeholder: const AssetImage('assets/loading.gif'),
            image: NetworkImage(url),
            width: width,
            height: height,
            fit: BoxFit.cover,
            imageErrorBuilder: (_, __, ___) =>
                _ErrorImage(height: height, width: width));
  }
}

class _ErrorImage extends StatelessWidget {
  const _ErrorImage({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/no-image.jpg',
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }
}
