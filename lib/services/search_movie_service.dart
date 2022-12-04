import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import 'dart:async';
import 'dart:convert' as json;
import 'package:http/http.dart' as http;

class SearchMovieService {
  final url = dotenv.env['URL']!;
  final timeout = dotenv.env['TIMEOUT']!;
  final String versionApi = dotenv.env['VERSION_API']!;

  final logger = Logger();

  Future<List<dynamic>> getSuggestions(
      String query, String type, int numberFetchMovies) async {
    List<dynamic> suggestions = [];

    if (query.isEmpty) return suggestions;

    final request = Uri.http(url, '/api/$versionApi/search/film', {
      'film': query,
      'lang': 'es',
      'type': type,
      'numberFetchMovies': numberFetchMovies.toString()
    });

    final response =
        await http.get(request).timeout(Duration(seconds: int.parse(timeout)));

    if (response.statusCode == 200) {
      suggestions = json.jsonDecode(response.body);
    }

    return suggestions;
  }
}
