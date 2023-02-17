import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:vims/exceptions/maintenance_exception.dart';
import 'dart:convert' as json;

import 'package:vims/models/movie.dart';

class TopMoviesService {
  final String url = dotenv.env['URL']!;
  final String timeout = dotenv.env['TIMEOUT']!;
  final String versionApi = dotenv.env['VERSION_API']!;

  final logger = Logger();

  Future<List<Movie>> getMopMovies(
      int from,
      int to,
      List<String> platforms,
      List<String> genres,
      bool excludeAnimation,
      int yearFrom,
      int yearTo) async {
    List<Movie> topMovies = [];

    final request = Uri.http(url, '/api/$versionApi/top/films', {
      'from': from.toString(),
      'to': to.toString(),
      'platforms': platforms.join(','),
      'genres': genres.join(','),
      'exclude_animation': excludeAnimation.toString(),
      'from_year': yearFrom.toString(),
      'to_year': yearTo.toString()
    });

    final response =
        await http.get(request).timeout(Duration(seconds: int.parse(timeout)));

    if (response.statusCode == 500) throw TimeoutException(response.body);

    if (response.statusCode == 503) {
      final body = json.jsonDecode(response.body);
      throw MaintenanceException(body['image'], body['message']);
    }

    if (response.statusCode == 200) {
      List<dynamic> aux = json.jsonDecode(response.body);
      for (var element in aux) {
        topMovies.add(Movie.fromIncompleteMovie(element));
      }
    }

    return topMovies;
  }
}
