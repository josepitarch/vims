import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/services/details_movie_service.dart';
import 'package:logger/logger.dart';

class DetailsMovieProvider extends ChangeNotifier {
  bool isLoading = false;
  bool existsError = false;
  final Map<String, Movie> openedMovies = {};
  final logger = Logger();

  DetailsMovieProvider();

  getDetailsMovie(String id) async {
    try {
      Movie? movie = await DetailsMovieService().getDetailsMovie(id);
      openedMovies[id] = movie!;
    } on SocketException catch (e) {
      existsError = true;
      logger.e(e.toString());
    } on TimeoutException catch (e) {
      existsError = true;
      logger.e(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
