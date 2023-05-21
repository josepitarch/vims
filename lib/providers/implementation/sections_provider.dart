import 'package:vims/models/section.dart';
import 'package:vims/providers/interface/base_providert.dart';
import 'package:vims/services/api/sections_service.dart';

class SectionsProvider extends BaseProvider<List<Section>> {
  DateTime lastUpdate = DateTime.now();

  SectionsProvider() : super(data: [], isLoading: true) {
    fetchData();
  }

  @override
  fetchData() async {
    isLoading = true;
    notifyListeners();
    getSections().then((sections) {
      data = sections;
      exception = null;
    }).catchError((e) {
      exception = e;
    }).whenComplete(() {
      isLoading = false;
      lastUpdate = DateTime.now();
      notifyListeners();
    });
  }

  @override
  onRefresh() async {
    data.clear();
    exception = null;
    fetchData();
  }
}
