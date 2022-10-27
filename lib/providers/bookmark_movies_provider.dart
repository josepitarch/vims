import 'package:flutter/cupertino.dart';
import 'package:scrapper_filmaffinity/database/bookmark_movies_database.dart';
import 'package:scrapper_filmaffinity/models/favorite_movie.dart';
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
        director: movie.director ?? '');

    bool response =
        await BookmarkMoviesDatabase.insertBookmarkMovie(favoriteMovie);
    if (response) bookmarkMovies.add(favoriteMovie);
    notifyListeners();

    return response;
  }

  deleteBookmarkMovie(String id) async {
    bool response = await BookmarkMoviesDatabase.deleteBookmarkMovie(id);
    if (response) bookmarkMovies.removeWhere((movie) => movie.id == id);
    notifyListeners();

    return response;
  }
}
