import 'dart:async';
import 'dart:convert' as json;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:vims/exceptions/maintenance_exception.dart';
import 'package:vims/models/suggestion.dart';

class SearchMovieService {
  final timeout = dotenv.env['TIMEOUT']!;

  final logger = Logger();

  Future<Map> getSuggestions(
      String query, String type, int from, String order) async {
    final url = dotenv.env['URL']!;

    if (query.isEmpty) return {'total': 0, 'suggestions': []};

    final request = Uri.http(url, '/api/v2/search/film', {
      'film': query,
      'lang': 'es',
      'type': type,
      'from': from.toString(),
      'order': order,
    });

    final response =
        await http.get(request).timeout(Duration(seconds: int.parse(timeout)));

    if (response.statusCode == 500 || response.statusCode == 502) {
      throw TimeoutException(response.body);
    }

    if (response.statusCode == 503) {
      final body = json.jsonDecode(response.body);
      throw MaintenanceException(body['image'], body['message']);
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.jsonDecode(response.body);
      final int total = body['total'];
      final List movies = body['movies'];
      final List<Suggestion> suggestions =
          movies.map((movie) => Suggestion.fromMap(movie)).toList();

      return {'total': total, 'suggestions': suggestions};
    }

    return {'total': 0, 'suggestions': []};
  }

  Future<List<Suggestion>> getAutocomplete(String query, String type) async {
    final url = dotenv.env['URL']!;
    List<Suggestion> suggestions = [];

    if (query.isEmpty) return suggestions;

    final request = Uri.http(url, '/api/v1/autocomplete', {
      'search': query,
    });

    final response =
        await http.get(request).timeout(Duration(seconds: int.parse(timeout)));

    if (response.statusCode == 500 || response.statusCode == 502) {
      throw TimeoutException(response.body);
    }

    if (response.statusCode == 503) {
      final body = json.jsonDecode(response.body);
      throw MaintenanceException(body['image'], body['message']);
    }

    if (response.statusCode == 200) {
      final List body = json.jsonDecode(response.body);
      body.forEach((movie) => suggestions.add(Suggestion.fromMap(movie)));
    }

    return suggestions;
  }
}
