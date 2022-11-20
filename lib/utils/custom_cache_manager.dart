import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static const keyTinyImages = 'cacheTinyImages';
  static CacheManager cacheTinyImages = CacheManager(
    Config(
      keyTinyImages,
      stalePeriod: const Duration(days: 5),
      maxNrOfCacheObjects: 20,
      repo: CacheObjectProvider(databaseName: keyTinyImages),
    ),
  );

  static const keyLargeImages = 'cacheLargeImages';

  static CacheManager cacheLargeImages = CacheManager(
    Config(
      keyLargeImages,
      stalePeriod: const Duration(days: 2),
      maxNrOfCacheObjects: 20,
      repo: CacheObjectProvider(databaseName: keyLargeImages),
    ),
  );
}
