import 'package:flutter/cupertino.dart';
import 'package:scrapper_filmaffinity/database/bookmark_movies_database.dart';
import 'package:scrapper_filmaffinity/models/favorite_movie.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';

class FavoriteMovieProvider extends ChangeNotifier {
  List<FavoriteMovie> favoriteMovies = [];
  bool isEmpty = true;

  FavoriteMovieProvider();

  addFavoriteMovie(Movie movie) async {
    FavoriteMovie favoriteMovie = FavoriteMovie(
        id: movie.id,
        poster: movie.poster,
        title: movie.title,
        director: movie.director ?? '');

    bool response =
        await BookmarkMoviesDatabase.insertFavoriteMovie(favoriteMovie);
    favoriteMovies.add(favoriteMovie);
    notifyListeners();

    return response;
  }

  deleteFavoriteMovie(String id) {
    favoriteMovies.removeWhere((movie) => movie.id == id);

    BookmarkMoviesDatabase.deleteFavoriteMovie(id).then((_) {
      notifyListeners();
    });
  }

  getFavoriteMovies() async {
    BookmarkMoviesDatabase.retrieveFavoriteMovies().then((value) => {
          favoriteMovies = value,
          isEmpty = value.isEmpty,
          notifyListeners(),
        });
  }
}
