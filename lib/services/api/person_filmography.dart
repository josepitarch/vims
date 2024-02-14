import 'dart:async';

import 'package:vims/models/actor_movie.dart';
import 'package:vims/models/paged_response.dart';
import 'package:vims/utils/api.dart';

Future<PagedResponse<ActorMovie>> getActorFilmography(int id, int page) async {
  final Map<String, String> parameters = {'page': page.toString()};
  final Map response =
      await api('person/filmography/$id', 1, queryParams: parameters);

  final List<ActorMovie> results = response['results']
      .map<ActorMovie>((topMovie) => ActorMovie.fromMap(topMovie))
      .toList();

  return PagedResponse<ActorMovie>(
      page: response['page'], limit: response['limit'], results: results);
}
