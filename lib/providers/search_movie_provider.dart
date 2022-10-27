import 'package:flutter/cupertino.dart';
import 'package:scrapper_filmaffinity/database/history_search_database.dart';
import 'package:scrapper_filmaffinity/services/search_movie_service.dart';

class SearchMovieProvider extends ChangeNotifier {
  String search = '';
  List<dynamic> movies = [];
  List<String> searchs = [];
  bool isLoading = false;

  SearchMovieProvider() {
    getHistorySearchers();
  }

  setSearch(String value) {
    search = value;
    notifyListeners();
  }

  getHistorySearchers() {
    HistorySearchDatabase.retrieveSearchs()
        .then((value) => searchs = value)
        .whenComplete(() => notifyListeners());
  }

  deleteAllSearchers() {
    HistorySearchDatabase.deleteAllSearchs()
        .then((value) => searchs.clear())
        .whenComplete(() => notifyListeners());
  }

  searchMovie(String search) async {
    isLoading = true;
    SearchMovieService()
        .getSuggestions(search)
        .then((value) => movies = value)
        .whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  insertAndSearchMovie(String search) {
    isLoading = true;
    notifyListeners();
    HistorySearchDatabase.insertSearch(search);
    this.search = search;
    searchs.insert(0, search);
    searchs = searchs.length >= 5 ? searchs.sublist(0, 5) : searchs;
    searchMovie(search);
  }

  onTap(String search) {
    this.search = search;
    isLoading = true;
    notifyListeners();
    searchMovie(search);
  }
}
