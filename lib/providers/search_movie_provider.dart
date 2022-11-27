import 'package:flutter/cupertino.dart';
import 'package:scrapper_filmaffinity/database/history_search_database.dart';
import 'package:scrapper_filmaffinity/enums/type_search.dart';
import 'package:scrapper_filmaffinity/services/search_movie_service.dart';

class SearchMovieProvider extends ChangeNotifier {
  String search = '';
  List<dynamic> movies = [];
  List<String> searchs = [];
  bool isLoading = false;
  final int numberFetchMovies = 3;
  TypeSearch type = TypeSearch.title;
  Exception? error;

  SearchMovieProvider() {
    getHistorySearchs();
  }

  clearSearch() {
    search = '';
    notifyListeners();
  }

  getHistorySearchs() {
    HistorySearchDatabase.getHistorySearchs()
        .then((value) => searchs = value)
        .whenComplete(() => notifyListeners());
  }

  deleteAllSearchs() {
    HistorySearchDatabase.deleteAllSearchs()
        .then((value) => searchs.clear())
        .whenComplete(() => notifyListeners());
  }

  searchMovie(String search) async {
    isLoading = true;
    this.search = search;
    notifyListeners();
    SearchMovieService()
        .getSuggestions(search, type.name, numberFetchMovies)
        .then((value) {
      movies = value;
      error = null;
    }).catchError((error) {
      this.error = error;
      return null;
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  insertHistorySearch(String search) {
    HistorySearchDatabase.insertSearch(search)
        .then((value) => value ? searchs.insert(0, search) : null);
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
}
