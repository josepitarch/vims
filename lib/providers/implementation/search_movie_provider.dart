import 'dart:async';

import 'package:logger/logger.dart';
import 'package:vims/models/enums/type_search.dart';
import 'package:vims/models/enums/type_search_view.dart';
import 'package:vims/models/suggestion.dart';
import 'package:vims/providers/interface/infinite_scroll_provider.dart';
import 'package:vims/repositories/implementation/search_history_repository.dart';
import 'package:vims/repositories/interface/search_history_repository.dart';
import 'package:vims/services/api/search_movie_service.dart';
import 'package:vims/utils/debounce.dart';

class SearchMovieProvider extends InfiniteScrollProvider<Suggestion> {
  final SearchHistoryRepository repository = SearchHistoryRepositoryImpl();
  String search = '';
  final String order = 'relevance';
  TypeSearch type = TypeSearch.title;
  final Logger logger = Logger();
  TypeSearchView typeSearchView = TypeSearchView.autocomplete;

  final _debouncer = Debouncer(milliseconds: 400);

  SearchMovieProvider() : super(page: 1, limit: 50) {
    isLoading = false;
  }

  @override
  fetchData() {
    isLoading = true;
    notifyListeners();

    getSuggestions(search.toLowerCase(), type.name, page, order).then((value) {
      total = value.total;
      hasNextPage = value.results.length < total!;
      data == null
          ? data = List.of(value.results)
          : data!.addAll(value.results);
      exception = null;
    }).whenComplete(() {
      isLoading = false;
      typeSearchView = TypeSearchView.suggestion;
      notifyListeners();
    });
  }

  getSuggestionsAutocomplete(String search) {
    isLoading = true;
    this.search = search;

    getAutocomplete(search.toLowerCase())
        .then((value) {
          data = value;
          exception = null;
        })
        .catchError((error) => exception = error)
        .whenComplete(() {
          isLoading = false;
          hasNextPage = false;
          total = null;
          typeSearchView = TypeSearchView.autocomplete;
          notifyListeners();
        });
  }

  clearSearch() {
    search = '';
    typeSearchView = TypeSearchView.autocomplete;
    resetPagination();
    notifyListeners();
  }

  Future<List<String>> getHistorySearchs() {
    return repository.getAllSearchHistory().then((value) => value);
  }

  insertHistorySearch(String search) {
    repository.addSearchHistory(search);
  }

  deleteAllSearchs() {
    repository.removeAllSearchHistory();
    notifyListeners();
  }

  onTapHistorySearch(String search) {
    this.search = search;
    data = null;
    fetchData();
  }

  @override
  onRefresh() {
    getSuggestionsAutocomplete(search);
  }

  void onChanged(String search) {
    search = search.trim();
    _debouncer.run(() {
      resetPagination();
      getSuggestionsAutocomplete(search);
    });
  }

  onSubmitted(String search) {
    if (search.isEmpty) return;
    _debouncer.cancel();
    this.search = search;
    data = null;
    page = 1;
    insertHistorySearch(search);
    fetchData();
  }
}
