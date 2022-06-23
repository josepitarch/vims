import 'package:flutter/cupertino.dart';
import 'package:scrapper_filmaffinity/database/favorite_movie_database.dart';
import 'package:scrapper_filmaffinity/models/favorite_movie.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';

class FavoriteMovieProvider extends ChangeNotifier {
  List<FavoriteMovie> favoriteMovies = [];
  bool isEmpty = true;

  FavoriteMovieProvider();

  addFavoriteMovie(Movie movie) {
    FavoriteMovie favoriteMovie = FavoriteMovie(
        id: movie.id,
        poster: movie.poster,
        title: movie.title,
        director: movie.director ?? '');
    
    favoriteMovies.add(favoriteMovie);
    
    FavoriteMovieDatabase.insertFavoriteMovie(favoriteMovie).then((_) {
      notifyListeners();
    });
  }

  deleteFavoriteMovie(String id) {
    favoriteMovies.removeWhere((movie) => movie.id == id);
    
    FavoriteMovieDatabase.deleteFavoriteMovie(id).then((_) {
      notifyListeners();
    });
  }

  getFavoriteMovies() async {
    FavoriteMovieDatabase.retrieveFavoriteMovies().then((value) => {
          favoriteMovies = value,
          isEmpty = value.isEmpty,
          notifyListeners(),
        });
  }
}
