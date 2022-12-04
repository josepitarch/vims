import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';

import 'package:scrapper_filmaffinity/models/section.dart';
import 'package:scrapper_filmaffinity/services/homepage_service.dart';

class HomepageProvider extends ChangeNotifier {
  List<Section> sections = [];
  Exception? error;
  bool isLoading = true;
  final logger = Logger();
  DateTime lastUpdate = DateTime.now();

  HomepageProvider() {
    getHomepageMovies();
  }

  getHomepageMovies() async {
    try {
      sections = await HomepageService().getHomepageMovies();
      error = null;
    } on SocketException catch (e) {
      error = e;
    } on TimeoutException catch (e) {
      error = e;
      logger.e(e.toString());
    } finally {
      isLoading = false;
      lastUpdate = DateTime.now();
      notifyListeners();
    }
  }

  onRefresh() async {
    sections.clear();
    error = null;
    isLoading = true;
    notifyListeners();
    getHomepageMovies();
  }
}
