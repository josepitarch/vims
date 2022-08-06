import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:scrapper_filmaffinity/enums/order_item.dart';

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
  Map<String, bool> platforms = {
    'netflix': false,
    'amazon': false,
    'hbo': false,
    'disney': false,
    'movistar': false,
    'filmin': false,
    'rakuten': false,
  };
  var logger = Logger();

  TopMoviesProvider() {
    getTopMovies().then((value) {
      movies = value;
      notifyListeners();
    });
  }

  Future<List<Movie>> getTopMovies(
      [selectedPlatforms = const <String>[]]) async {
    try {
      if (isLoading) return [];
      isLoading = true;
      await Future.delayed(const Duration(seconds: 2));
      return await TopMoviesService()
          .getMopMovies(from, to, selectedPlatforms, [], excludeAnimation);
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

  applyFilters() {
    List<String> selectedPlatforms =
        platforms.keys.where((key) => platforms[key] == true).toList();
    hasFilters = true;

    getTopMovies(selectedPlatforms).then((value) {
      movies = value;
      notifyListeners();
    });
  }

  removeFilters() {
    platforms.forEach((key, value) {
      platforms[key] = false;
    });
    hasFilters = false;

    getTopMovies().then((value) {
      movies = value;
      notifyListeners();
    });
  }
}
