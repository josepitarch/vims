import 'package:flutter/cupertino.dart';

import 'package:logger/logger.dart';
import 'package:vims/enums/title_sections.dart';

import 'package:vims/models/section.dart';
import 'package:vims/services/homepage_service.dart';

class HomepageProvider extends ChangeNotifier {
  List<Section> sections = [];
  Map<String, List<MovieSection>> seeMore = {};
  bool isLoading = true;
  final logger = Logger();
  DateTime lastUpdate = DateTime.now();
  Map errors = TitleSectionEnum.values
      .asMap()
      .map((key, value) => MapEntry(value.toString().split('.').last, null));

  HomepageProvider() {
    getHomepageMovies();
  }

  getHomepageMovies() async {
    try {
      sections = await HomepageService().getHomepageMovies();
      errors['th'] = null;
    } on Exception catch (e) {
      errors['th'] = e;
      logger.e(e.toString());
    } finally {
      isLoading = false;
      lastUpdate = DateTime.now();
      notifyListeners();
    }
  }

  getSeeMore(String title) async {
    try {
      List<MovieSection> movieSections =
          await HomepageService().getSeeMore(title);
      seeMore[title] = movieSections;
      errors[title] = null;
    } on Exception catch (e) {
      errors[title] = e;
      logger.e(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  onRefresh() {
    sections.clear();
    seeMore.clear();
    errors.clear();
    isLoading = true;
    notifyListeners();
    getHomepageMovies();
  }
}
