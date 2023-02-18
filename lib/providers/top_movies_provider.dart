import 'package:flutter/foundation.dart';

import 'package:logger/logger.dart';
import 'package:vims/enums/genres.dart';
import 'package:vims/enums/mode_views.dart';
import 'package:vims/enums/platforms.dart';
import 'package:vims/models/filters.dart';

import 'package:vims/models/movie.dart';
import 'package:vims/services/top_movies_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

List<int> randomNumbers = List.generate(20, (index) => index * 30)..shuffle();

final Filters initialFilters = Filters(
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

class TopMoviesProvider extends ChangeNotifier {
  int from = 0;
  List<Movie> movies = [];
  bool isLoading = false;
  Exception? error;
  bool hasFilters = false;
  ModeView modeView = ModeView.list;
  double scrollPosition = 0;

  Filters currentFilters = Filters(
      platforms: initialFilters.platforms,
      genres: initialFilters.genres,
      isAnimationExcluded: initialFilters.isAnimationExcluded,
      yearFrom: initialFilters.yearFrom,
      yearTo: initialFilters.yearTo);

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

      movies.addAll(response);
      // movies = hasFilters ? movies : movies
      //   ..shuffle();

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
    notifyListeners();

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

    getTopMovies();
  }

  removeFilters() {
    movies.clear();
    currentFilters.removeFilters();
    hasFilters = false;
    from = 0;
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
