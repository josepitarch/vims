import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:scrapper_filmaffinity/enums/genres.dart';
import 'package:scrapper_filmaffinity/enums/orders.dart';
import 'package:scrapper_filmaffinity/enums/platforms.dart';
import 'package:scrapper_filmaffinity/models/filters.dart';

import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/services/top_movies_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scrapper_filmaffinity/utils/current_year.dart';

class TopMoviesProvider extends ChangeNotifier {
  int from = 0;
  int to = 30;

  OrderItem orderBy = OrderItem.average;
  List<Movie> movies = [];
  bool isLoading = false;
  bool existsError = false;
  bool hasFilters = false;

  Filters filters = Filters(
      platforms: {},
      genres: {},
      isAnimationExcluded: false,
      yearFrom: int.parse(dotenv.env['YEAR_FROM']!),
      yearTo: getCurrentYear());

  var logger = Logger();

  TopMoviesProvider(String language) {
    for (var genre in Genres.values) {
      filters.genres[genre] = false;
    }
    for (var platform in Platforms.values) {
      filters.platforms[platform.value] = false;
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
      List<String> selectedPlatforms = filters.platforms.keys
          .where((key) => filters.platforms[key] == true)
          .toList();

      List<String> selectedGenres = filters.genres.keys
          .where((key) => filters.genres[key] == true)
          .map((genre) => genre.name)
          .toList();

      return await TopMoviesService().getMopMovies(
          from,
          to,
          selectedPlatforms,
          selectedGenres,
          filters.isAnimationExcluded,
          filters.yearFrom,
          filters.yearTo);
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
    bool value = filters.platforms[platform]!;
    filters.platforms[platform] = !value;
  }

  final Map<String, Function> sorts = {
    'average': (List<Movie> movies) => movies.sort((a, b) =>
        double.parse(b.average.replaceFirst(',', '.'))
            .compareTo(double.parse(a.average.replaceFirst(',', '.')))),
    'year': (List<Movie> movies) =>
        movies.sort((a, b) => int.parse(a.year).compareTo(int.parse(b.year))),
    'random': (List<Movie> movies) => movies.shuffle(),
  };

  applyFilters(Filters filters) {
    hasFilters = true;
    movies = [];
    notifyListeners();
    filters.platforms = {
      ...this.filters.platforms,
      ...filters.platforms,
    };
    this.filters.genres = {
      ...this.filters.genres,
      ...filters.genres,
    };

    this.filters.yearFrom = filters.yearFrom;
    this.filters.yearTo = filters.yearTo;
    this.filters.isAnimationExcluded = filters.isAnimationExcluded;

    getTopMovies().then((value) {
      movies = value;
      notifyListeners();
    });
  }

  removeFilters() {
    filters.platforms.forEach((key, value) {
      filters.platforms[key] = false;
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
