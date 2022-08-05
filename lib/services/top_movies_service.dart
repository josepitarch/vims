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

  Future<List<Movie>> getMyTopMovies() async {
    List<Movie> myTopMovies = [];

    final request = Uri.http(url, '/api/my/top/films', {});

    final response =
        await http.get(request).timeout(Duration(seconds: int.parse(timeout)));

    if (response.statusCode == 200) {
      List<dynamic> aux = json.jsonDecode(response.body);
      for (var element in aux) {
        myTopMovies.add(Movie.fromMap(element));
      }
    }

    return myTopMovies;
  }

  Future<List<Movie>> getMopMovies(String from, String to, List<String> platforms,
  List<String> genres, bool excludeAnimation) async {

    List<Movie> topMovies = [];
    String exclude = excludeAnimation ? 'animation' : '';

    final request = Uri.http(url, '/api/top/films',{
      'from': from,
      'to': to,
      'platforms': platforms.join(','),
      'genres': genres.join(','),
      'exclude': exclude
    });

    final response =
        await http.get(request).timeout(Duration(seconds: int.parse(timeout)));

    if (response.statusCode == 200) {
      List<dynamic> aux = json.jsonDecode(response.body);
      for (var element in aux) {
        topMovies.add(Movie.fromIncompleteMovie(element));
      }
    }

    return topMovies;
  }
}
