import 'package:flutter/cupertino.dart';
import 'package:scrapper_filmaffinity/database/bookmark_movies_database.dart';
import 'package:scrapper_filmaffinity/models/bookmark_movie.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';

class BookmarkMoviesProvider extends ChangeNotifier {
  List<BookmarkMovie> bookmarkMovies = [];

  BookmarkMoviesProvider() {
    getBookmarkMovies();
  }

  getBookmarkMovies() async {
    BookmarkMoviesDatabase.getBookmarkMovies()
        .then((value) => bookmarkMovies = value)
        .whenComplete(() => notifyListeners());
  }

  Future<bool> insertBookmarkMovie(Movie movie) async {
    BookmarkMovie favoriteMovie = BookmarkMovie(
        id: movie.id,
        poster: movie.poster,
        title: movie.title,
        director: movie.director ?? '',
        average: movie.average);

    bool response =
        await BookmarkMoviesDatabase.insertBookmarkMovie(favoriteMovie);
    if (response) bookmarkMovies.add(favoriteMovie);
    notifyListeners();

    return response;
  }

  deleteBookmarkMovie(Movie movie) async {
    bool response = await BookmarkMoviesDatabase.deleteBookmarkMovie(movie.id);
    if (response) {
      bookmarkMovies.removeWhere((element) => element.id == movie.id);
    }
    notifyListeners();

    return response;
  }

  deleteAllBookmarkMovies() async {
    bool response = await BookmarkMoviesDatabase.deleteAllBookmarkMovies();
    if (response) bookmarkMovies.clear();
    notifyListeners();

    return response;
  }
}
