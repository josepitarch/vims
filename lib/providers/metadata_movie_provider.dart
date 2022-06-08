import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:scrapper_filmaffinity/models/movie.dart';

class MetadataMovieProvier extends ChangeNotifier {
  Movie? movie;

  MetadataMovieProvier();

  getMetadataMovie(String id) async {
    var url = Uri.http('35.246.48.193:8000', '/api/homepage', {});

    var response = await http.get(url);
    if (response.statusCode == 200) {
      movie = Movie.fromJson(response.body);
      notifyListeners();
    }
  }
}
