import 'package:flutter/foundation.dart';
import 'package:vims/enums/genres.dart';

class Filters {
  Map<String, bool> platforms;
  Map<Genres, bool> genres;
  bool isAnimationExcluded;
  int yearFrom;
  int yearTo;

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
