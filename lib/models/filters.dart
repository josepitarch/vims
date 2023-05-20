import 'package:flutter_dotenv/flutter_dotenv.dart';

class Filters {
  List<String> platforms;
  List<String> genres;
  bool isAnimationExcluded;
  int yearFrom;
  int yearTo;

  Filters.origin()
      : platforms = [],
        genres = [],
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
    platforms.clear();
    genres.clear();
    isAnimationExcluded = true;
  }

  bool equals(Filters filters) {
    return platforms == filters.platforms &&
        genres == filters.genres &&
        isAnimationExcluded == filters.isAnimationExcluded &&
        yearFrom == filters.yearFrom &&
        yearTo == filters.yearTo;
  }
}
