import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:scrapper_filmaffinity/enums/genres.dart';
import 'package:scrapper_filmaffinity/enums/orders.dart';
import 'package:scrapper_filmaffinity/enums/platforms.dart';

import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/services/top_movies_service.dart';

class TopMoviesProvider extends ChangeNotifier {
  int from = 0;
  int to = 30;
  bool excludeAnimation = false;
  OrderItem orderBy = OrderItem.average;
  List<Movie> movies = [];
  bool isLoading = false;
  bool existsError = false;
  bool hasFilters = false;
  Map<String, bool> platforms = {};

  Map<String, bool> genres = {};
  var logger = Logger();

  TopMoviesProvider() {
    for (var genre in Genres.values) {
      genres[genre.value['es']!] = false;
    }
    for (var platform in Platforms.values) {
      platforms[platform.value] = false;
    }
    getTopMovies().then((value) {
      movies = value;
      notifyListeners();
    });
  }

  Future<List<Movie>> getTopMovies() async {
    try {
      if (isLoading) return [];
      isLoading = true;

      //await Future.delayed(const Duration(seconds: 2));
      List<String> selectedPlatforms =
          platforms.keys.where((key) => platforms[key] == true).toList();

      List<String> selectedGenres = genres.keys.where((key) => genres[key] == true).toList();

      return await TopMoviesService()
          .getMopMovies(from, to, selectedPlatforms, selectedGenres, excludeAnimation);
    } on SocketException catch (e) {
      existsError = true;
      logger.e(e.toString());
    } on TimeoutException catch (e) {
      existsError = true;
      logger.e(e.toString());
    } finally {
      isLoading = false;
    }

    return [];
  }

  void setPlatform(String platform) {
    bool value = platforms[platform]!;
    platforms[platform] = !value;
  }

  final Map<String, Function> sorts = {
    'average': (List<Movie> movies) => movies.sort((a, b) =>
        double.parse(b.average.replaceFirst(',', '.'))
            .compareTo(double.parse(a.average.replaceFirst(',', '.')))),
    'year': (List<Movie> movies) =>
        movies.sort((a, b) => int.parse(a.year).compareTo(int.parse(b.year))),
    'random': (List<Movie> movies) => movies.shuffle(),
  };

  applyFilters(Map<String, bool> selectedPlatforms, Map<String, bool> selectedGenres) {
    hasFilters = true;
    movies = [];
    notifyListeners();
    platforms = {
      ...platforms,
      ...selectedPlatforms,
    };
    genres = {
      ...genres,
      ...selectedGenres,
    };

    getTopMovies().then((value) {
      movies = value;
      notifyListeners();
    });
  }

  removeFilters() {
    platforms.forEach((key, value) {
      platforms[key] = false;
    });
    hasFilters = false;
    from = 0;
    to = 30;
    movies = [];
    notifyListeners();

    getTopMovies().then((value) {
      movies = value;
      notifyListeners();
    });
  }
}
