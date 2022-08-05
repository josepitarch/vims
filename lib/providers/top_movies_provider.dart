import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:scrapper_filmaffinity/enums/order_item.dart';

import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/services/top_movies_service.dart';

class TopMoviesProvider extends ChangeNotifier {
  String from = '0';
  String to = '30';
  bool excludeAnimation = true;

  final Map<String, bool> platforms = {
    'netflix': false,
    'amazon': false,
    'hbo': false,
    'disney': false,
    'movistar': false,
    'filmin': false,
    'rakuten': false,
  };

  OrderItem orderBy = OrderItem.average;

  final Map<String, Function> sorts = {
    'average': (List<Movie> movies) => movies.sort((a, b) =>
        double.parse(b.average.replaceFirst(',', '.'))
            .compareTo(double.parse(a.average.replaceFirst(',', '.')))),
    'year': (List<Movie> movies) =>
        movies.sort((a, b) => int.parse(a.year).compareTo(int.parse(b.year))),
    'random': (List<Movie> movies) => movies.shuffle(),
  };

  List<Movie> movies = [];
  List<Movie> filteredMovies = [];
  bool existsError = false;
  bool hasFilters = false;
  var logger = Logger();

  TopMoviesProvider() {
    getTopMovies();
  }

  getTopMovies() async {
    try {
      List<String> selectedPlatforms = platforms.keys.where((key) => platforms[key] == true).toList();
      movies = await TopMoviesService().getMopMovies(from, to, selectedPlatforms, [], excludeAnimation);
      filteredMovies = List.from(movies);
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

  void setPlatform(String platform) {
    bool value = platforms[platform]!;
    platforms[platform] = !value;
  }

  applyFilters() {
    List<String> selectedPlatforms =
        platforms.keys.where((key) => platforms[key] == true).toList();

    if (selectedPlatforms.isEmpty) {
      filteredMovies = List.from(movies);
    } else {
      for (var platform in selectedPlatforms) {
        filteredMovies = movies
            .where((movie) => movie.platforms!
                .any((element) => element.toLowerCase().contains(platform)))
            .toList();
      }
    }

    if (orderBy.name.isNotEmpty) {
      sorts[orderBy.name]!(filteredMovies);
    }

    hasFilters = true;

    notifyListeners();
  }

  removeFilters() {
    platforms.forEach((key, value) {
      platforms[key] = false;
    });
    filteredMovies = List.from(movies);
    orderBy = OrderItem.average;
    hasFilters = false;
    notifyListeners();
  }
}
