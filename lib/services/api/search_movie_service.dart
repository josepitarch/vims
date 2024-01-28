import 'package:vims/models/paged_response.dart';
import 'package:vims/models/movie_suggestion.dart';
import 'package:vims/models/suggestion.dart';
import 'package:vims/utils/request.dart';

Future<PagedResponse<MovieSuggestion>> getMovieSuggestions(
    String query, int page, String order) async {
  if (query.isEmpty) return PagedResponse.origin();

  final Map<String, String> parameters = {
    'q': query,
    'page': page.toString(),
    'order': order,
  };

  final Map response = await request('search/movie', 1, parameters);

  final List<MovieSuggestion> results = response['results']
      .map<MovieSuggestion>((suggestion) => MovieSuggestion.fromMap(suggestion))
      .toList();

  return PagedResponse<MovieSuggestion>(
      page: response['page'],
      limit: response['limit'],
      total: response['total'],
      results: results);
}

Future<Suggestion> getAutocomplete(String query) async {
  if (query.isEmpty) return Suggestion(movies: [], actors: []);

  final Map<String, String> parameters = {'search': query};

  return await request('autocomplete', 1, parameters)
      .then((value) => Suggestion.fromMap(value));
}
