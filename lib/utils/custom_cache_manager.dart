import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static const key = 'cacheImages';
  static CacheManager cacheImages = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 5),
      maxNrOfCacheObjects: 20,
      repo: CacheObjectProvider(databaseName: key),
    ),
  );
}
