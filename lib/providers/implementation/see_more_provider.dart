import 'package:vims/models/section.dart';
import 'package:vims/providers/interface/base_providert.dart';
import 'package:vims/services/see_more_service.dart';

class SeeMoreProvider extends BaseProvider<Map<String, List<MovieSection>>> {
  Map errors = {};

  SeeMoreProvider() : super(data: {}, isLoading: true);

  getSeeMore(String title) {
    isLoading = true;
    SeeMoreService()
        .getSeeMore(title)
        .then((movieSections) {
          data[title] = movieSections;
          errors[title] = null;
        })
        .catchError((e) => errors[title] = e)
        .whenComplete(() {
          isLoading = false;
          notifyListeners();
        });
  }

  onRefresh() {
    data.clear();
    errors.clear();
  }

  onRefreshError(String title) {
    errors[title] = null;
    notifyListeners();
  }
}
