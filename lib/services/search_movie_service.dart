import 'package:vims/models/paged_response.dart';
import 'package:vims/models/suggestion.dart';
import 'package:vims/utils/request.dart';

class SearchMovieService {
  Future<PagedResponse<Suggestion>> getSuggestions(
      String query, String type, int from, String order) async {
    if (query.isEmpty) return PagedResponse.origin();

    final Map<String, String> parameters = {
      'movie': query,
      'from': from.toString(),
      'order': order,
      'type': type,
    };

    final Map response = await request('search/movie', 'v2', parameters);

    final List<Suggestion> results = response['results']
        .map<Suggestion>((suggestion) => Suggestion.fromMap(suggestion))
        .toList();

    return PagedResponse<Suggestion>(
        page: response['page'],
        limit: response['limit'],
        total: response['total'],
        results: results);
  }

  Future<List<Suggestion>> getAutocomplete(String query) async {
    if (query.isEmpty) return [];

    final Map<String, String> parameters = {'search': query};

    final response = await request('autocomplete', 'v1', parameters);

    return response['movies']
        .map<Suggestion>((suggestion) => Suggestion.fromMap(suggestion))
        .toList();
  }
}
