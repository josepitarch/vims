import 'package:vims/models/section.dart';
import 'package:vims/utils/api.dart';

Future<List<Section>> getSections() async {
  final List response = await api('sections', 1);

  return response.map((section) => Section.fromMap(section)).toList();
}

Future<List<MovieSection>> getSection(String id) async {
  Map section = await api('section/$id', 1);
  List movies = section['movies'];

  return movies.map((movie) => MovieSection.fromMap(movie)).toList();
}
