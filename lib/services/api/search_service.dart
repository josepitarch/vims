import 'package:vims/models/person.dart';
import 'package:vims/models/paged_response.dart';
import 'package:vims/models/movie_suggestion.dart';
import 'package:vims/models/suggestion.dart';
import 'package:vims/utils/api.dart';

Future<PagedResponse<MovieSuggestion>> getMovieSuggestions(
    String query, int page, String order) async {
  if (query.isEmpty) return PagedResponse.origin();

  final Map<String, String> parameters = {
    'q': query,
    'page': page.toString(),
    'order': order,
  };

  final Map response = await api('search/movie', 1, queryParams: parameters);

  final List<MovieSuggestion> results = response['results']
      .map<MovieSuggestion>((suggestion) => MovieSuggestion.fromMap(suggestion))
      .toList();

  return PagedResponse<MovieSuggestion>(
      page: response['page'],
      limit: response['limit'],
      total: response['total'],
      results: results);
}

Future<PagedResponse<Person>> getPeopleSuggestions(
    String query, int page, String order) async {
  if (query.isEmpty) return PagedResponse.origin();

  final Map<String, String> parameters = {
    'q': query,
    'page': page.toString(),
    'order': order,
  };

  final Map response = await api('search/person', 1, queryParams: parameters);

  final List<Person> results = response['results']
      .map<Person>((suggestion) => Person.fromMap(suggestion))
      .toList();

  return PagedResponse<Person>(
      page: response['page'],
      limit: response['limit'],
      total: response['total'],
      results: results);
}

Future<Suggestion> getAutocomplete(String query) async {
  if (query.isEmpty) return Suggestion(movies: [], actors: []);

  final Map<String, String> parameters = {'search': query};

  return await api('autocomplete', 1, queryParams: parameters)
      .then((value) => Suggestion.fromMap(value));
}
