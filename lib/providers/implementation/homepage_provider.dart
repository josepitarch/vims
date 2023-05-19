import 'package:vims/models/section.dart';
import 'package:vims/providers/interface/base_providert.dart';
import 'package:vims/services/sections_service.dart';

class HomepageProvider extends BaseProvider<List<Section>> {
  List<Section> sections = [];
  Map<String, List<MovieSection>> seeMore = {};
  DateTime lastUpdate = DateTime.now();

  HomepageProvider() {
    getHomepageMovies();
  }

  getHomepageMovies() async {
    try {
      sections = await HomepageService().getSections();
      exception = null;
    } on Exception catch (e) {
      exception = e;
    } finally {
      isLoading = false;
      lastUpdate = DateTime.now();
      notifyListeners();
    }
  }

  onRefresh() async {
    sections.clear();
    seeMore.clear();
    exception = null;
    isLoading = true;
    notifyListeners();
    getHomepageMovies();
  }
}
