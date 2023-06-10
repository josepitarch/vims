import 'package:vims/models/section.dart';
import 'package:vims/providers/interface/base_providert.dart';
import 'package:vims/services/api/see_more_service.dart';

class SeeMoreProvider extends BaseProvider<Map<String, List<MovieSection>>> {
  Map errors = {};
  late String title;

  SeeMoreProvider() : super(data: {}, isLoading: true);

  @override
  fetchData() {
    isLoading = true;
    getSeeMore(title).then((movieSections) {
      data![title] = movieSections;
      errors[title] = null;
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  fetchSection(String title) {
    this.title = title;
    fetchData();
  }

  @override
  onRefresh() {
    data!.clear();
    errors.clear();
  }

  onRefreshError(String title) {
    errors[title] = null;
    notifyListeners();
  }
}
