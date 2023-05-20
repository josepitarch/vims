import 'package:vims/models/section.dart';
import 'package:vims/utils/request.dart';

class SectionsService {
  Future<List<Section>> getSections() async {
    final List response = await request('sections', 'v2');

    return response.map((section) => Section.fromMap(section)).toList();
  }
}
