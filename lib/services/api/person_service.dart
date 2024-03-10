import 'dart:async';

import 'package:vims/models/actor.dart';
import 'package:vims/models/actor_movie.dart';
import 'package:vims/models/paged_response.dart';
import 'package:vims/utils/api.dart';

Future<Actor> getPersonProfile(int id) async {
  final Map<String, dynamic> response = await api('person/$id/profile', 1);

  return Actor.fromMap(response);
}

Future<PagedResponse<ActorMovie>> getPersonFilmography(int id, int page) async {
  final Map<String, String> parameters = {'page': page.toString()};
  final Map response =
      await api('person/$id/filmography', 1, queryParams: parameters);

  final List<ActorMovie> results = response['results']
      .map<ActorMovie>((topMovie) => ActorMovie.fromMap(topMovie))
      .toList();

  return PagedResponse<ActorMovie>(
      page: response['page'], limit: response['limit'], results: results);
}
