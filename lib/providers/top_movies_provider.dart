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
  int to = 210;
  List<Movie> movies = [];
  bool isLoading = false;
  Exception? error;
  bool hasFilters = false;
  Map<String, Movie> openedMovies = {};

  Filters filters = Filters(
      platforms: {for (var platform in Platforms.values) platform.value: false},
      genres: {for (var e in Genres.values) e: false},
      orderBy: OrderBy.shuffle,
      isAnimationExcluded: true,
      yearFrom: int.parse(dotenv.env['YEAR_FROM']!),
      yearTo: getCurrentYear());

  var logger = Logger();

  TopMoviesProvider() {
    getTopMovies();
  }

  getTopMovies() async {
    try {
      isLoading = true;
      List<String> selectedPlatforms = filters.platforms.keys
          .where((key) => filters.platforms[key] == true)
          .toList();

      List<String> selectedGenres = filters.genres.keys
          .where((key) => filters.genres[key] == true)
          .map((genre) => genre.name)
          .toList();

      movies = await TopMoviesService().getMopMovies(
          from,
          to,
          selectedPlatforms,
          selectedGenres,
          filters.isAnimationExcluded,
          filters.yearFrom,
          filters.yearTo);

      movies = filters.orderBy.func(movies);

      error = null;
    } on SocketException catch (e) {
      error = e;
      logger.e(e.toString());
    } on TimeoutException catch (e) {
      error = e;
      logger.e(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  setPlatform(String platform) {
    bool value = filters.platforms[platform]!;
    filters.platforms[platform] = !value;
  }

  applyFilters(Filters filters) {
    hasFilters = true;
    movies.clear();
    notifyListeners();
    this.filters.platforms = {
      ...this.filters.platforms,
      ...filters.platforms,
    };
    this.filters.genres = {
      ...this.filters.genres,
      ...filters.genres,
    };

    this.filters.orderBy = filters.orderBy;
    this.filters.yearFrom = filters.yearFrom;
    this.filters.yearTo = filters.yearTo;
    this.filters.isAnimationExcluded = filters.isAnimationExcluded;

    getTopMovies();
  }

  removeFilters() {
    filters.removeFiltes();
    hasFilters = false;
    from = 0;
    to = 30;
    movies = [];
    notifyListeners();

    getTopMovies();
  }

  onRefresh() {
    movies.clear();
    error = null;
    isLoading = true;
    notifyListeners();
    getTopMovies();
  }
}
