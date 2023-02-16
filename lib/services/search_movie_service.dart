import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import 'dart:async';
import 'dart:convert' as json;
import 'package:http/http.dart' as http;
import 'package:vims/exceptions/maintenance_exception.dart';

class SearchMovieService {
  final url = dotenv.env['URL']!;
  final timeout = dotenv.env['TIMEOUT']!;
  final String versionApi = dotenv.env['VERSION_API']!;
  final int numberFetchMovies = int.parse(dotenv.env['NUMBER_FETCH_MOVIES']!);

  final logger = Logger();

  Future getSuggestions(String query, String type) async {
    List suggestions = [];
    int countFetch = 0;

    if (query.isEmpty) return suggestions;

    final request = Uri.http(url, '/api/$versionApi/search/film', {
      'film': query,
      'lang': 'es',
      'type': type,
      'numberFetchMovies': numberFetchMovies.toString()
    });

    final response =
        await http.get(request).timeout(Duration(seconds: int.parse(timeout)));

    if (response.statusCode == 500) throw TimeoutException(response.body);

    if (response.statusCode == 503) {
      final body = json.jsonDecode(response.body);
      throw MaintenanceException(body['image'], body['message']);
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.jsonDecode(response.body);
      countFetch = body['countFetch'];
      suggestions = body['movies'];
    }

    return {'countFetch': countFetch, 'suggestions': suggestions};
  }
}
