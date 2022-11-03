import 'package:scrapper_filmaffinity/enums/genres.dart';
import 'package:scrapper_filmaffinity/enums/orders.dart';

class Filters {
  Map<String, bool> platforms;
  Map<Genres, bool> genres;
  OrderBy orderBy;
  bool isAnimationExcluded;
  int yearFrom;
  int yearTo;

  Filters(
      {required this.platforms,
      required this.genres,
      required this.orderBy,
      required this.isAnimationExcluded,
      required this.yearFrom,
      required this.yearTo});

  removeFiltes() {
    platforms.forEach((key, value) {
      platforms[key] = false;
    });
    genres.forEach((key, value) {
      genres[key] = false;
    });
    orderBy = OrderBy.shuffle;
    isAnimationExcluded = true;
  }
}
