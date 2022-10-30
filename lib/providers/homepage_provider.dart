import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';

import 'package:scrapper_filmaffinity/models/section.dart';
import 'package:scrapper_filmaffinity/services/homepage_service.dart';

import '../models/movie.dart';

class HomepageProvider extends ChangeNotifier {
  List<Section> sections = [];
  bool existsError = false;
  bool isLoading = false;
  Map<String, Movie> openedMovies = {};
  final logger = Logger();

  HomepageProvider() {
    getHomepageMovies();
  }

  getHomepageMovies() async {
    try {
      isLoading = true;
      sections = await HomepageService().getHomepageMovies();
      existsError = false;
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

  onRefresh() async {
    sections.clear();
    isLoading = true;
    notifyListeners();
    getHomepageMovies();
  }
}
