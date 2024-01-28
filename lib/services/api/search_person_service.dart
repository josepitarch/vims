import 'package:vims/models/actor.dart';
import 'package:vims/models/paged_response.dart';
import 'package:vims/utils/request.dart';

Future<PagedResponse<Actor>> getActorSuggestions(
    String query, int page, String order) async {
  if (query.isEmpty) return PagedResponse.origin();

  final Map<String, String> parameters = {
    'q': query,
    'page': page.toString(),
    'order': order,
  };

  final Map response = await request('search/person', 1, parameters);

  final List<Actor> results = response['results']
      .map<Actor>((suggestion) => Actor.fromMap(suggestion))
      .toList();

  return PagedResponse<Actor>(
      page: response['page'],
      limit: response['limit'],
      total: response['total'],
      results: results);
}
