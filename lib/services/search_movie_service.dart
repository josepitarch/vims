import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import 'dart:async';
import 'dart:convert' as json;
import 'package:http/http.dart' as http;
import 'package:vims/models/suggestion.dart';

class SearchMovieService {
  final timeout = dotenv.env['TIMEOUT']!;

  final logger = Logger();

  Future<List<Suggestion>> getSuggestions(String query, String type) async {
    List<Suggestion> suggestions = [];
    int countFetch = 0;

    if (query.isEmpty) return suggestions;

    final request =
        Uri.https('www.filmaffinity.com', '/es/search-ac.ajax.php', {
      'action': 'searchTerm',
    });

    Map<String, String> formMap = {
      'term': query,
      'dataType': 'json',
    };

    final response = await http
        .post(request,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: formMap,
            encoding: Encoding.getByName('utf-8'))
        .timeout(Duration(seconds: int.parse(timeout)));

    if (response.statusCode != 200) throw TimeoutException(response.body);

    Map<String, dynamic> body = json.jsonDecode(response.body);
    List results = body['results'];
    final int index = results.indexWhere((e) => e['id'] == 'sep');
    if (index != -1) {
      results = results.sublist(0, index);
    } else {
      results = results.where((e) => e['id'] != 'se-a').toList();
    }
    suggestions = results.map((e) => Suggestion.fromMap(e)).toList();

    return suggestions;
  }
}
