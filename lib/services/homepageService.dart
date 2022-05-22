import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;

import 'package:scrapper_filmaffinity/models/homepage.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';

class HomepageService {
  final url = dotenv.env['URL']!;
  final timeout = dotenv.env['TIMEOUT']!;
  

  Future<List<Section>> getHomepageMovies() async {
    List<Section> homepageMovies = [];

    final request = Uri.http(url, '/api/homepage', {});

    final response =
        await http.get(request).timeout(Duration(seconds: int.parse(timeout)));

    if (response.statusCode == 200) {
      List<dynamic> aux = json.jsonDecode(response.body);
      for (var element in aux) {
        homepageMovies.add(Section.fromMap(element));
      }
    }

    return homepageMovies;
  }

  Future<Movie> getMetadataMovie(String id) async {
    var request = Uri.http(url, '/api/metadata/film', {'id': id});
    var response = await http.get(request);

    return Movie.fromJson(response.body);
  }
}
