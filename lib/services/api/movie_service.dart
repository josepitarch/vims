import 'dart:async';

import 'package:vims/models/movie.dart';
import 'package:vims/utils/request.dart';

Future<Movie> getMovie(int id) async {
  final Map<String, dynamic> response = await request('movie/$id', 2);

  return Movie.fromMap(response);
}
