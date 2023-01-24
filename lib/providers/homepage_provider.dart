import 'package:flutter/cupertino.dart';

import 'package:logger/logger.dart';

import 'package:vims/models/section.dart';
import 'package:vims/services/homepage_service.dart';

class HomepageProvider extends ChangeNotifier {
  List<Section> sections = [];
  Map<String, List<MovieSection>> seeMore = {};
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
    } on Exception catch (e) {
      error = e;
      logger.e(e.toString());
    } finally {
      isLoading = false;
      lastUpdate = DateTime.now();
      notifyListeners();
    }
  }

  getSeeMore(String title, bool isRelease) async {
    try {
      List<MovieSection> movieSections =
          await HomepageService().getSeeMore(title, isRelease);
      seeMore[title] = movieSections;
      error = null;
    } on Exception catch (e) {
      error = e;
      logger.e(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  onRefresh() async {
    sections.clear();
    seeMore.clear();
    error = null;
    isLoading = true;
    notifyListeners();
    getHomepageMovies();
  }
}
