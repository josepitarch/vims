import 'dart:async';

import 'package:logger/logger.dart';
import 'package:vims/database/history_search_database.dart';
import 'package:vims/enums/type_search.dart';
import 'package:vims/models/suggestion.dart';
import 'package:vims/providers/interface/infinite_scroll_provider.dart';
import 'package:vims/services/search_movie_service.dart';
import 'package:vims/utils/debounce.dart';

enum TypeData { suggestions, autocomplete }

class SearchMovieProvider extends InfiniteScrollProvider<Suggestion> {
  String search = '';
  final String order = 'relevance';
  TypeSearch type = TypeSearch.title;
  final Logger logger = Logger();
  TypeData typeData = TypeData.suggestions;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  SearchMovieProvider() : super(page: 1, limit: 50) {
    isLoading = false;
    getHistorySearchs();
  }

  getSuggestions(String search) {
    isLoading = true;
    notifyListeners();

    SearchMovieService()
        .getSuggestions(search, type.name, page, order)
        .then((value) {
      total = value.total;
      final List<Suggestion> body = value.results;
      hasNextPage = body.length < total!;
      if (body.isNotEmpty) data.addAll(value.results);
      exception = null;
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  getSuggestionsAutocomplete(String search) {
    isLoading = true;
    this.search = search;

    SearchMovieService()
        .getAutocomplete(search)
        .then((value) {
          data = value;
          exception = null;
        })
        .catchError((error) => exception = error)
        .whenComplete(() {
          isLoading = false;
          hasNextPage = false;
          total = null;
          notifyListeners();
        });
  }

  clearSearch() {
    search = '';
    total = null;
    data.clear();
    notifyListeners();
  }

  Future getHistorySearchs() {
    return HistorySearchDatabase.getHistorySearchs().then((value) => value);
  }

  insertHistorySearch(String movie) {
    HistorySearchDatabase.insertSearch(movie);
  }

  deleteAllSearchs() {
    HistorySearchDatabase.deleteAllSearchs();
    notifyListeners();
  }

  onTapHistorySearch(String search) {
    this.search = search;
    getSuggestions(search);
  }

  onRefresh() {
    getSuggestionsAutocomplete(search);
  }

  void onChanged(String search) {
    search = search.trim();
    debouncer.value = '';
    debouncer.onValue = (value) async {
      data.clear();
      scrollPosition = 0;
      typeData = TypeData.autocomplete;
      getSuggestionsAutocomplete(search);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = search;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }

  onSubmitted(String search) {
    if (search.isEmpty) return;
    this.search = search;
    data.clear();
    page = 1;
    typeData = TypeData.suggestions;
    insertHistorySearch(search);
    getSuggestions(search);
  }

  @override
  fetchNextPage() {
    page = page + 1;
    getSuggestions(search);
  }
}
