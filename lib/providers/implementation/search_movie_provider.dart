import 'dart:async';

import 'package:logger/logger.dart';
import 'package:vims/models/movie_suggestion.dart';
import 'package:vims/providers/interface/infinite_scroll_provider.dart';
import 'package:vims/repositories/implementation/search_history_repository.dart';
import 'package:vims/repositories/interface/search_history_repository.dart';
import 'package:vims/services/api/search_movie_service.dart';
import 'package:vims/utils/debounce.dart';

final class SearchMovieProvider extends InfiniteScrollProvider<MovieSuggestion> {
  final SearchHistoryRepository repository = SearchHistoryRepositoryImpl();
  String search = '';
  final String order = 'relevance';

  final Logger logger = Logger();

  final _debouncer = Debouncer(milliseconds: 400);

  SearchMovieProvider() : super(page: 1, limit: 50) {
    isLoading = false;
  }

  @override
  fetchData() {
    isLoading = true;
    notifyListeners();

    getMovieSuggestions(search.toLowerCase(), page, order).then((value) {
      total = value.total;
      hasNextPage = value.results.length < total!;
      data == null
          ? data = List.of(value.results)
          : data!.addAll(value.results);
      exception = null;
    }).catchError((e) {
      exception = e;
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  getSuggestionsAutocomplete(String search) {
    isLoading = true;
    this.search = search;

    getAutocomplete(search.toLowerCase()).then((value) {
      data = value.movies;
      exception = null;
    }).catchError((e) {
      exception = e;
    }).whenComplete(() {
      isLoading = false;
      hasNextPage = false;
      total = null;
      notifyListeners();
    });
  }

  Future<List<String>> getHistorySearchs() {
    return repository.getAllSearchMoviesHistory().then((value) => value);
  }

  insertHistorySearch(String search) {
    repository.addSearchMovieHistory(search);
  }

  deleteAllSearchs() {
    repository.removeAllSearchMoviesHistory();
    notifyListeners();
  }

  onTapHistorySearch(String search) {
    this.search = search;
    onRefresh();
  }

  void onChanged(String search) {
    search = search.trim();
    _debouncer.run(() {
      getSuggestionsAutocomplete(search);
    });
  }

  onSubmitted(String search) {
    if (search.isEmpty) return;
    _debouncer.cancel();
    this.search = search;
    onRefresh();
    insertHistorySearch(search);
  }
}
