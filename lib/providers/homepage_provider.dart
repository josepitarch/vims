import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';

import 'package:scrapper_filmaffinity/models/section.dart';
import 'package:scrapper_filmaffinity/services/homepage_service.dart';

class HomepageProvider extends ChangeNotifier {
  List<Section> sections = [];
  bool existsError = false;
  bool isLoading = true;
  final logger = Logger();
  DateTime lastUpdate = DateTime.now();

  HomepageProvider() {
    getHomepageMovies();
  }

  getHomepageMovies() async {
    try {
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
      lastUpdate = DateTime.now();
      notifyListeners();
    }
  }

  onRefresh() async {
    sections.clear();
    existsError = false;
    isLoading = true;
    notifyListeners();
    getHomepageMovies();
  }
}
