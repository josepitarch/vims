import 'package:flutter/cupertino.dart';
import 'package:vims/database/history_search_database.dart';
import 'package:vims/enums/type_search.dart';
import 'package:vims/services/search_movie_service.dart';

class SearchMovieProvider extends ChangeNotifier {
  String search = '';
  List<dynamic> movies = [];
  bool isLoading = false;
  final int numberFetchMovies = 0;
  TypeSearch type = TypeSearch.title;
  Exception? error;

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
}
