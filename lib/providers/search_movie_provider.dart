import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:vims/database/history_search_database.dart';
import 'package:vims/enums/type_search.dart';
import 'package:vims/models/suggestion.dart';
import 'package:vims/services/search_movie_service.dart';
import 'package:vims/utils/debounce.dart';

class SearchMovieProvider extends ChangeNotifier {
  String search = '';
  List<Suggestion> suggestions = [];
  int total = -1;
  int from = 0;
  final String order = 'relevance';
  bool isLoading = false;
  TypeSearch type = TypeSearch.title;
  Exception? error;
  double scrollPosition = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Suggestion>> _suggestionsStream =
      StreamController<List<Suggestion>>.broadcast();

  Stream<List<Suggestion>> get suggestionsStream => _suggestionsStream.stream;

  SearchMovieProvider() {
    getHistorySearchs();
  }

  clearSearch() {
    search = '';
    total = -1;
    suggestions.clear();
    _suggestionsStream.sink.add(suggestions);
    notifyListeners();
  }

  Future getHistorySearchs() {
    return HistorySearchDatabase.getHistorySearchs().then((value) => value);
  }

  deleteAllSearchs() {
    HistorySearchDatabase.deleteAllSearchs();
    notifyListeners();
  }

  getSuggestionsAutocomplete(String search) async {
    total = -1;
    SearchMovieService().getAutocomplete(search, type.name).then((value) {
      this.search = search;
      suggestions = value;
      _suggestionsStream.sink.add(suggestions);
      error = null;
    }).catchError((error) {
      this.error = error;
    }).whenComplete(() => notifyListeners());
  }

  getSuggestions(String search) async {
    isLoading = true;
    notifyListeners();
    SearchMovieService()
        .getSuggestions(search, type.name, from, order)
        .then((value) {
      total = value['total'];
      final List body = value['suggestions'];
      if (body.isNotEmpty) suggestions.addAll(value['suggestions']);
      _suggestionsStream.sink.add(suggestions);
      error = null;
    }).whenComplete(() {
      isLoading = false;
      from += 50;
      notifyListeners();
    });
  }

  insertHistorySearch(String search) {
    HistorySearchDatabase.insertSearch(search);
  }

  onTapHistorySearch(String search) {
    this.search = search;
    getSuggestions(search);
  }

  onRefresh() {
    isLoading = true;
    notifyListeners();
    getSuggestionsAutocomplete(search);
  }

  void onChanged(String search) {
    search = search.trim();
    debouncer.value = '';
    debouncer.onValue = (value) async {
      getSuggestionsAutocomplete(search);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = search;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
