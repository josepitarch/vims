import 'package:vims/models/section.dart';
import 'package:vims/providers/interface/base_providert.dart';
import 'package:vims/services/api/sections_service.dart';

final class SectionProvider
    extends BaseProvider<Map<String, List<MovieSection>>> {
  Map errors = {};
  late String title;

  SectionProvider() : super(data: {}, isLoading: true);

  @override
  fetchData() {
    isLoading = true;
    getSection(title).then((movieSections) {
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
