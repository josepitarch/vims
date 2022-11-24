import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/services/details_movie_service.dart';
import 'package:logger/logger.dart';

class DetailsMovieProvider extends ChangeNotifier {
  late String id;
  bool isLoading = true;
  Exception? error;
  final Map<String, Movie> openedMovies = {};
  final logger = Logger();

  DetailsMovieProvider();

  getDetailsMovie(String id) async {
    try {
      Movie? movie = await DetailsMovieService().getDetailsMovie(id);
      openedMovies[id] = movie!;
    } on SocketException catch (e) {
      error = e;
      logger.e(e.toString());
    } on TimeoutException catch (e) {
      error = e;
      logger.e(e.toString());
    } finally {
      this.id = id;
      isLoading = false;
      notifyListeners();
    }
  }

  onRefresh() async {
    isLoading = true;
    error = null;
    notifyListeners();
    getDetailsMovie(id);
  }
}
