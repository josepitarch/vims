import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;

import 'package:scrapper_filmaffinity/models/movie.dart';

class TopMoviesService {
  final url = dotenv.env['URL']!;
  final timeout = dotenv.env['TIMEOUT']!;
  final logger = Logger();

  Future<List<Movie>> getTopMovies() async {
    List<Movie> topMovies = [];

    final request = Uri.http(url, '/api/my/top/films', {});

    final response =
        await http.get(request).timeout(Duration(seconds: int.parse(timeout)));

    if (response.statusCode == 200) {
      List<dynamic> aux = json.jsonDecode(response.body);
      for (var element in aux) {
        topMovies.add(Movie.fromMap(element));
      }
    }

    return topMovies;
  }
}
