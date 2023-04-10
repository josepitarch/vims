import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:vims/models/section.dart';
import 'package:vims/services/see_more_service.dart';

class SeeMoreProvider extends ChangeNotifier {
  Map<String, List<MovieSection>> seeMore = {};
  bool isLoading = false;
  final logger = Logger();
  Map errors = {};

  SeeMoreProvider();

  getSeeMore(String title, bool isRelease) {
    SeeMoreService().getSeeMore(title).then((movieSections) {
      seeMore[title] = movieSections;
      errors[title] = null;
    }).catchError((error) {
      errors[title] = error;
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  onRefresh() {
    seeMore.clear();
    errors.clear();
    isLoading = true;
    notifyListeners();
  }

  onRefreshError(String title) {
    errors[title] = null;
    notifyListeners();
  }
}
