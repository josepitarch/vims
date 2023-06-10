import 'dart:async';

import 'package:vims/models/filters.dart';
import 'package:vims/models/paged_response.dart';
import 'package:vims/models/topMovie.dart';
import 'package:vims/utils/request.dart';

Future<PagedResponse<TopMovie>> getTopMovies(Filters filters,
    [int page = 1]) async {
  final Map<String, String> parameters = {
    'page': page.toString(),
    'platforms': filters.platforms.join(','),
    'genres': filters.genres.join(','),
    'exclude_animation': filters.isAnimationExcluded.toString(),
    'from_year': filters.yearFrom.toString(),
    'to_year': filters.yearTo.toString()
  };

  final Map response = await request('top/movies', 2, parameters);
  final List<TopMovie> results = response['results']
      .map<TopMovie>((topMovie) => TopMovie.fromMap(topMovie))
      .toList();

  return PagedResponse<TopMovie>(
      page: response['page'], limit: response['limit'], results: results);
}
