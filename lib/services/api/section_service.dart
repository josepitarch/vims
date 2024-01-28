import 'dart:async';

import 'package:vims/models/section.dart';
import 'package:vims/utils/request.dart';

Future<List<MovieSection>> getSeeMore(String id) async {
  Map section = await request('section/$id', 1);
  List movies = section['movies'];

  return movies.map((movie) => MovieSection.fromMap(movie)).toList();
}
