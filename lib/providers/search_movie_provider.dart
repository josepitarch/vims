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
  bool isLoading = false;
  TypeSearch type = TypeSearch.title;
  Exception? error;

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
    notifyListeners();
  }

  Future getHistorySearchs() {
    return HistorySearchDatabase.getHistorySearchs().then((value) => value);
  }

  deleteAllSearchs() {
    HistorySearchDatabase.deleteAllSearchs();
    notifyListeners();
  }

  searchMovie(String search) async {
    isLoading = true;
    this.search = search;
    //notifyListeners();
    SearchMovieService().getSuggestions(search, type.name).then((value) {
      suggestions = value;
      print(suggestions);
      _suggestionsStream.add(suggestions);
      error = null;
    }).catchError((error) {
      this.error = error;
    }).whenComplete(() {
      isLoading = false;
      //notifyListeners();
    });
  }

  insertHistorySearch(String search) {
    HistorySearchDatabase.insertSearch(search);
  }

  onTapHistorySearch(String search) {
    this.search = search;
    isLoading = true;
    notifyListeners();
    searchMovie(search);
  }

  onRefresh() {
    isLoading = true;
    notifyListeners();
    searchMovie(search);
  }

  void onChanged(String search) {
    search = search.trim();
    debouncer.value = '';
    debouncer.onValue = (value) async {
      searchMovie(search);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = search;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
