import 'package:flutter/cupertino.dart';

import 'package:logger/logger.dart';
import 'package:vims/enums/title_sections.dart';

import 'package:vims/models/section.dart';
import 'package:vims/services/homepage_service.dart';

class SeeMoreProvider extends ChangeNotifier {
  Map<String, List<MovieSection>> seeMore = {};
  bool isLoading = true;
  final logger = Logger();
  Map errors = TitleSectionEnum.values
      .asMap()
      .map((key, value) => MapEntry(value.toString().split('.').last, null));

  SeeMoreProvider();

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
    seeMore.clear();
    errors.clear();
    isLoading = true;
    notifyListeners();
  }
}
