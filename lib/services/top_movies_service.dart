import 'dart:async';

import 'package:vims/models/paged_response.dart';
import 'package:vims/models/topMovie.dart';
import 'package:vims/utils/request.dart';

class TopMoviesService {
  Future<PagedResponse<TopMovie>> getTopMovies(
      {int from = 0,
      List<String> platforms = const [],
      List<String> genres = const [],
      bool excludeAnimation = true,
      int yearFrom = 1990,
      int yearTo = 2023}) async {
    final Map<String, String> parameters = {
      'from': from.toString(),
      'platforms': platforms.join(','),
      'genres': genres.join(','),
      'exclude_animation': excludeAnimation.toString(),
      'from_year': yearFrom.toString(),
      'to_year': yearTo.toString()
    };

    final Map response = await request('top/movies', 'v2', parameters);
    final List<TopMovie> results = response['results']
        .map<TopMovie>((topMovie) => TopMovie.fromMap(topMovie))
        .toList();

    return PagedResponse<TopMovie>(
        page: response['page'], limit: response['limit'], results: results);
  }
}
