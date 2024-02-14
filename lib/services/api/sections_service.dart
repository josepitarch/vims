import 'package:vims/models/section.dart';
import 'package:vims/utils/api.dart';

Future<List<Section>> getSections() async {
  final List response = await api('sections', 1);

  return response.map((section) => Section.fromMap(section)).toList();
}
