import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static const _keyTinyImages = 'cacheTinyImages';
  static CacheManager cacheTinyImages = CacheManager(
    Config(
      _keyTinyImages,
      stalePeriod: const Duration(days: 5),
      maxNrOfCacheObjects: 20,
      repo: CacheObjectProvider(databaseName: _keyTinyImages),
    ),
  );

  static const _keyLargeImages = 'cacheLargeImages';

  static CacheManager cacheLargeImages = CacheManager(
    Config(
      _keyLargeImages,
      stalePeriod: const Duration(days: 2),
      maxNrOfCacheObjects: 20,
      repo: CacheObjectProvider(databaseName: _keyLargeImages),
    ),
  );
}
