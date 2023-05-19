import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:vims/models/section.dart';
import 'package:vims/services/sections_service.dart';

class HomepageProvider extends ChangeNotifier {
  List<Section> sections = [];
  Map<String, List<MovieSection>> seeMore = {};
  bool isLoading = true;
  final logger = Logger();
  DateTime lastUpdate = DateTime.now();
  Exception? error;

  HomepageProvider() {
    getHomepageMovies();
  }

  getHomepageMovies() async {
    try {
      sections = await HomepageService().getSections();
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

  onRefresh() async {
    sections.clear();
    seeMore.clear();
    error = null;
    isLoading = true;
    notifyListeners();
    getHomepageMovies();
  }
}
