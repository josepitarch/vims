import 'package:flutter/cupertino.dart';
import 'package:scrapper_filmaffinity/database/favorite_movie_database.dart';
import 'package:scrapper_filmaffinity/models/favorite_movie.dart';

class FavoriteMovieProvider extends ChangeNotifier {
  List<FavoriteMovie> favoriteMovies = [];
  bool isEmpty = true;

  FavoriteMovieProvider();

  addFavoriteMovie(FavoriteMovie favoriteMovie) {
    favoriteMovies.add(favoriteMovie);
    FavoriteMovieDatabase.insertFavoriteMovie(favoriteMovie).then((_) {
      notifyListeners();
    });
  }

  getFavoriteMovies() async {
    favoriteMovies = await FavoriteMovieDatabase.retrieveFavoriteMovies();
    favoriteMovies.isNotEmpty ? isEmpty = false : isEmpty = true;
    notifyListeners();
  }
}
