import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:scrapper_filmaffinity/models/movie.dart';

class DetailsMovieService {
  final String url = dotenv.env['URL']!;
  final String timeout = dotenv.env['TIMEOUT']!;
  final String versionApi = dotenv.env['VERSION_API']!;

  final logger = Logger();

  Future<Movie?> getDetailsMovie(String id) async {
    final request = Uri.http(url, '/api/$versionApi/metadata/film/$id', {});

    final response =
        await http.get(request).timeout(Duration(seconds: int.parse(timeout)));

    if (response.statusCode == 200) {
      return Movie.fromJson(response.body);
    }

    return null;
  }
}
