import 'package:logger/logger.dart';
import 'package:vims/models/enums/mode_views.dart';
import 'package:vims/models/filters.dart';
import 'package:vims/models/top.dart';
import 'package:vims/providers/interface/infinite_scroll_provider.dart';
import 'package:vims/services/api/top_service.dart';

List<int> randomNumbers = List.generate(20, (index) => index + 1)..shuffle();

final class TopMoviesProvider extends InfiniteScrollProvider<TopMovie> {
  bool hasFilters = false;
  ModeView modeView = ModeView.list;

  Filters currentFilters = Filters.origin();

  var logger = Logger();

  TopMoviesProvider() : super(page: 1, limit: 30) {
    fetchData();
  }

  @override
  fetchData() {
    isLoading = true;
    notifyListeners();
    final int currentPage = hasFilters ? page : randomNumbers.removeLast();

    getTopMovies(currentFilters, currentPage).then((value) {
      final List<TopMovie> movies = value.results;
      if (!hasFilters) movies.shuffle();
      hasNextPage = movies.length == limit;
      data == null
          ? data = List.from(value.results)
          : data!.addAll(value.results);
      exception = null;
    }).catchError((e) {
      exception = e;
    }).whenComplete(() {
      isLoading = false;
      scrollPosition = 0;
      notifyListeners();
    });
  }

  applyFilters(Filters filters) {
    if (currentFilters.equals(filters)) return;

    hasFilters = true;
    currentFilters = filters;
    data = null;

    fetchData();
  }

  removeFilters() {
    randomNumbers = List.generate(20, (index) => index * 30)..shuffle();

    onRefresh();
  }

  @override
  onRefresh() {
    currentFilters = Filters.origin();
    hasFilters = false;
    super.onRefresh();
  }

  setModeView() {
    modeView = modeView == ModeView.list ? ModeView.grid : ModeView.list;
    notifyListeners();
  }
}
