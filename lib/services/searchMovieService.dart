import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert' as json;
import 'package:http/http.dart' as http;

import 'package:scrapper_filmaffinity/models/movie.dart';

class SearchMovieService {
  final url = dotenv.env['URL']!;
  final timeout = dotenv.env['TIMEOUT']!;
  final logger = Logger();

  Future<List<Movie>> getSuggestions(String query) async {
    List<Movie> suggestions = [];
    try {
      if (query.isEmpty) {
        return suggestions;
      }

      final request =
          Uri.http(url, '/api/search/film', {'film': query, 'lang': 'es'});

      final response = await http
          .get(request)
          .timeout(Duration(seconds: int.parse(timeout)));

      if (response.statusCode == 200) {
        List<dynamic> aux = json.jsonDecode(response.body);
        for (var element in aux) {
          suggestions.add(Movie.fromMap(element));
        }
      }
    } on SocketException catch (e) {
      logger.e(e.toString());
    } on TimeoutException catch (e) {
      logger.e(e.toString());
    }

    return suggestions;
  }
}
