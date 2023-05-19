import 'package:vims/models/section.dart';
import 'package:vims/providers/interface/base_providert.dart';
import 'package:vims/services/see_more_service.dart';

class SeeMoreProvider extends BaseProvider<Map<String, List<MovieSection>>> {
  Map errors = {};

  SeeMoreProvider() : super();

  getSeeMore(String title) {
    SeeMoreService().getSeeMore(title).then((movieSections) {
      data[title] = movieSections;
      errors[title] = null;
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  onRefresh() {
    data.clear();
    errors.clear();
    isLoading = true;
    notifyListeners();
  }

  onRefreshError(String title) {
    errors[title] = null;
    notifyListeners();
  }
}
