import 'package:scrapper_filmaffinity/enums/genres.dart';

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
}
