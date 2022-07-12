import 'package:flutter/cupertino.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/services/search_movie_service.dart';

class SearchMovieProvider extends ChangeNotifier {
  String search = '';
  List<Movie> movies = [];

  SearchMovieProvider();

  getSearchMovie(String search) async {
    this.search = search;
    movies = await SearchMovieService().getSuggestions(search);
    notifyListeners();
  }
  
}
