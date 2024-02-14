import 'dart:async';

import 'package:vims/models/section.dart';
import 'package:vims/utils/api.dart';

Future<List<MovieSection>> getSeeMore(String id) async {
  Map section = await api('section/$id', 1);
  List movies = section['movies'];

  return movies.map((movie) => MovieSection.fromMap(movie)).toList();
}
