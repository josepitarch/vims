import 'package:flutter/cupertino.dart';

import 'package:logger/logger.dart';
import 'package:vims/enums/genres.dart';
import 'package:vims/enums/mode_views.dart';
import 'package:vims/enums/orders.dart';
import 'package:vims/enums/platforms.dart';
import 'package:vims/models/filters.dart';

import 'package:vims/models/movie.dart';
import 'package:vims/services/top_movies_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TopMoviesProvider extends ChangeNotifier {
  int from = 0;
  int to = 210;
  List<Movie> movies = [];
  bool isLoading = false;
  Exception? error;
  bool hasFilters = false;
  OrderBy orderBy = OrderBy.shuffle;
  Map<String, Movie> openedMovies = {};
  ModeView modeView = ModeView.list;

  Filters filters = Filters(
      platforms: {
        for (var platform in Platforms.values)
          if (platform.showInTopFilters) platform.name: false
      },
      genres: {
        for (var e in Genres.values) e: false
      },
      isAnimationExcluded: true,
      yearFrom: int.parse(dotenv.env['YEAR_FROM']!),
      yearTo: DateTime.now().year);

  var logger = Logger();

  TopMoviesProvider() {
    getTopMovies();
  }

  getTopMovies() async {
    try {
      isLoading = true;
      List<String> selectedPlatforms = filters.platforms.keys
          .where((key) => filters.platforms[key] == true)
          .toList();

      List<String> selectedGenres = filters.genres.keys
          .where((key) => filters.genres[key] == true)
          .map((genre) => genre.name)
          .toList();

      movies = await TopMoviesService().getMopMovies(
          from,
          to,
          selectedPlatforms,
          selectedGenres,
          filters.isAnimationExcluded,
          filters.yearFrom,
          filters.yearTo);

      movies = orderBy.func(movies);

      error = null;
    } on Exception catch (e) {
      error = e;
      logger.e(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  setPlatform(String platform) {
    bool value = filters.platforms[platform]!;
    filters.platforms[platform] = !value;
  }

  applyFilters(Filters filters) {
    hasFilters = true;
    movies.clear();
    notifyListeners();
    this.filters.platforms = {
      ...this.filters.platforms,
      ...filters.platforms,
    };
    this.filters.genres = {
      ...this.filters.genres,
      ...filters.genres,
    };

    this.filters.yearFrom = filters.yearFrom;
    this.filters.yearTo = filters.yearTo;
    this.filters.isAnimationExcluded = filters.isAnimationExcluded;

    getTopMovies();
  }

  removeFilters() {
    filters.removeFiltes();
    hasFilters = false;
    from = 0;
    to = 30;
    movies = [];
    notifyListeners();

    getTopMovies();
  }

  onRefresh() {
    movies.clear();
    error = null;
    isLoading = true;
    notifyListeners();
    getTopMovies();
  }

  setOrderBy(OrderBy orderBy) {
    this.orderBy = orderBy;
    movies = orderBy.func(movies);
    notifyListeners();
  }

  setModeView(ModeView modeView) {
    this.modeView = modeView;
    notifyListeners();
  }
}
