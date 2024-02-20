import 'dart:async';

import 'package:vims/models/enums/http_method.dart';
import 'package:vims/models/movie.dart';
import 'package:vims/models/review.dart';
import 'package:vims/utils/api.dart';

Future<Movie> getMovie(int id) async {
  final Map<String, dynamic> response = await api('movie/$id', 1);

  return Movie.fromMap(response);
}

Future<UserReview> createUserReview(
    String userId, int movieId, UserReview review) async {
  final Map<String, dynamic> response = await api('movie/$movieId/reviews', 1,
      method: HttpMethod.POST,
      queryParams: {'user_id': userId},
      body: {'review': review.toMap()});

  return UserReview.fromMap(response);
}
