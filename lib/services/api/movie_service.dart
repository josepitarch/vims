import 'dart:async';

import 'package:vims/models/movie.dart';
import 'package:vims/utils/request.dart';

Future<Movie> getMovie(int id) async {
  final Map<String, dynamic> response = await request('movie/$id', 1);

  return Movie.fromMap(response);
}

Future<dynamic> createUserReview(int userId, int movieId, String review) async {
  final Map<String, dynamic> response =
      await request('movie/$movieId/review', 1, body: review);

  return response;
}
