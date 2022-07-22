import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';

import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/services/top_movies_service.dart';

class TopMoviesProvider extends ChangeNotifier {
  Movie? selectedMovie;
  List<Movie> movies = [];
  bool existsError = false;
  var logger = Logger();

  TopMoviesProvider() {
    getTopMovies();
  }

  getTopMovies() async {
    try {
      movies = await TopMoviesService().getMopMovies();
    } on SocketException catch (e) {
      existsError = true;
      logger.e(e.toString());
    } on TimeoutException catch (e) {
      existsError = true;
      logger.e(e.toString());
    } finally {
      notifyListeners();
    }
    notifyListeners();
  }
}
