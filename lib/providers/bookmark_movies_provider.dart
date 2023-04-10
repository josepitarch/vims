import 'package:flutter/cupertino.dart';
import 'package:vims/database/bookmark_movies_database.dart';
import 'package:vims/models/bookmark_movie.dart';
import 'package:vims/models/movie.dart';

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
    final double? rating =
        movie.rating != null ? double.parse(movie.rating.toString()) : null;

    BookmarkMovie favoriteMovie = BookmarkMovie(
        id: movie.id,
        poster: movie.poster,
        title: movie.title,
        director: movie.director ?? '',
        rating: rating);

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
