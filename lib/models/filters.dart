import 'package:flutter/foundation.dart';
import 'package:vims/enums/genres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vims/enums/platforms.dart';

class Filters {
  Map<String, bool> platforms;
  Map<Genres, bool> genres;
  bool isAnimationExcluded;
  int yearFrom;
  int yearTo;

  Filters.origin()
      : platforms = {
          for (var platform in Platforms.values)
            if (platform.showInTopFilters) platform.name: false
        },
        genres = {for (var e in Genres.values) e: false},
        isAnimationExcluded = true,
        yearFrom = int.parse(dotenv.env['YEAR_FROM']!),
        yearTo = DateTime.now().year;

  Filters(
      {required this.platforms,
      required this.genres,
      required this.isAnimationExcluded,
      required this.yearFrom,
      required this.yearTo});

  removeFilters() {
    platforms.forEach((key, value) {
      platforms[key] = false;
    });
    genres.forEach((key, value) {
      genres[key] = false;
    });
    isAnimationExcluded = true;
  }

  bool equals(Filters filters) {
    return mapEquals(platforms, filters.platforms) &&
        mapEquals(genres, filters.genres) &&
        isAnimationExcluded == filters.isAnimationExcluded &&
        yearFrom == filters.yearFrom &&
        yearTo == filters.yearTo;
  }
}
