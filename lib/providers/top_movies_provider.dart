import 'package:flutter/foundation.dart';

import 'package:logger/logger.dart';
import 'package:vims/enums/mode_views.dart';
import 'package:vims/models/filters.dart';

import 'package:vims/models/movie.dart';
import 'package:vims/services/top_movies_service.dart';

List<int> randomNumbers = List.generate(20, (index) => index * 30)..shuffle();

class TopMoviesProvider extends ChangeNotifier {
  int from = 0;
  List<Movie> movies = [];
  bool isLoading = false;
  Exception? error;
  bool hasFilters = false;
  ModeView modeView = ModeView.list;
  double scrollPosition = 0;

  Filters currentFilters = Filters.origin();

  var logger = Logger();

  TopMoviesProvider() {
    getTopMovies();
  }

  getTopMovies() async {
    try {
      isLoading = true;
      notifyListeners();
      final List<String> selectedPlatforms = currentFilters.platforms.keys
          .where((key) => currentFilters.platforms[key] == true)
          .toList();

      final List<String> selectedGenres = currentFilters.genres.keys
          .where((key) => currentFilters.genres[key] == true)
          .map((genre) => genre.name)
          .toList();
      final int fromParam;
      if (hasFilters) {
        fromParam = from;
        from += 30;
      } else {
        fromParam = randomNumbers.removeLast();
      }

      final List<Movie> response = await TopMoviesService().getTopMovies(
          from: fromParam,
          platforms: selectedPlatforms,
          genres: selectedGenres,
          excludeAnimation: currentFilters.isAnimationExcluded,
          yearFrom: currentFilters.yearFrom,
          yearTo: currentFilters.yearTo);

      if (!hasFilters) response.shuffle();
      movies.addAll(response);
      error = null;
    } on Exception catch (e) {
      error = e;
      logger.e(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  applyFilters(Filters filters) {
    if (currentFilters.equals(filters)) return;

    hasFilters = true;
    movies.clear();
    from = 0;
    scrollPosition = 0;

    currentFilters.platforms = {
      ...currentFilters.platforms,
      ...filters.platforms,
    };
    currentFilters.genres = {
      ...currentFilters.genres,
      ...filters.genres,
    };

    currentFilters.yearFrom = filters.yearFrom;
    currentFilters.yearTo = filters.yearTo;
    currentFilters.isAnimationExcluded = filters.isAnimationExcluded;

    scrollPosition = 0;

    getTopMovies();
  }

  removeFilters() {
    movies.clear();
    currentFilters = Filters.origin();
    hasFilters = false;
    from = 0;
    scrollPosition = 0;

    randomNumbers = List.generate(20, (index) => index * 30)..shuffle();

    getTopMovies();
  }

  onRefresh() {
    movies.clear();
    error = null;
    isLoading = true;
    hasFilters = false;
    notifyListeners();
    TopMoviesService().getTopMovies().then((value) => movies = value);
  }

  setModeView() {
    modeView = modeView == ModeView.list ? ModeView.grid : ModeView.list;
    notifyListeners();
  }
}
