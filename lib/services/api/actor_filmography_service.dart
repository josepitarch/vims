import 'dart:async';

import 'package:vims/models/actor_movie.dart';
import 'package:vims/models/paged_response.dart';
import 'package:vims/utils/request.dart';

Future<PagedResponse<ActorMovie>> getActorFilmography(int id, int page) async {
  final Map<String, dynamic> parameters = {'page': page.toString()};
  final Map response = await request('actor/filmography/$id', 2, parameters);

  final List<ActorMovie> results = response['results']
      .map<ActorMovie>((topMovie) => ActorMovie.fromMap(topMovie))
      .toList();

  return PagedResponse<ActorMovie>(
      page: response['page'], limit: response['limit'], results: results);
}
