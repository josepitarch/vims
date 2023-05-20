import 'package:logger/logger.dart';
import 'package:vims/enums/mode_views.dart';
import 'package:vims/models/filters.dart';
import 'package:vims/models/topMovie.dart';
import 'package:vims/providers/interface/infinite_scroll_provider.dart';
import 'package:vims/services/top_movies_service.dart';

List<int> randomNumbers = List.generate(20, (index) => index + 1)..shuffle();

class TopMoviesProvider extends InfiniteScrollProvider<TopMovie> {
  bool hasFilters = false;
  ModeView modeView = ModeView.list;

  Filters currentFilters = Filters.origin();

  var logger = Logger();

  TopMoviesProvider() : super(page: 1, limit: 30) {
    getTopMovies();
  }

  getTopMovies() {
    isLoading = true;
    notifyListeners();
    final int currentPage = hasFilters ? page : randomNumbers.removeLast();

    TopMoviesService()
        .getTopMovies(currentFilters, currentPage)
        .then((value) {
          final List<TopMovie> movies = value.results;
          if (!hasFilters) movies.shuffle();
          hasNextPage = movies.length == limit;
          data.addAll(value.results);
          exception = null;
        })
        .catchError((e) => exception = e)
        .whenComplete(() {
          isLoading = false;
          notifyListeners();
        });
  }

  applyFilters(Filters filters) {
    if (currentFilters.equals(filters)) return;

    hasFilters = true;
    data.clear();
    page = 1;
    scrollPosition = 0;

    currentFilters.platforms = [
      ...currentFilters.platforms,
      ...filters.platforms
    ];
    currentFilters.genres = [...currentFilters.genres, ...filters.genres];

    currentFilters.yearFrom = filters.yearFrom;
    currentFilters.yearTo = filters.yearTo;
    currentFilters.isAnimationExcluded = filters.isAnimationExcluded;

    scrollPosition = 0;

    getTopMovies();
  }

  removeFilters() {
    data.clear();
    currentFilters = Filters.origin();
    hasFilters = false;
    page = 1;
    scrollPosition = 0;

    randomNumbers = List.generate(20, (index) => index * 30)..shuffle();

    getTopMovies();
  }

  onRefresh() {
    data.clear();
    currentFilters = Filters.origin();
    exception = null;
    hasFilters = false;

    getTopMovies();
  }

  setModeView() {
    modeView = modeView == ModeView.list ? ModeView.grid : ModeView.list;
    notifyListeners();
  }

  @override
  fetchNextPage() {
    page = page + 1;
    getTopMovies();
  }
}
