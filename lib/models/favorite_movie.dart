import 'package:scrapper_filmaffinity/models/movie.dart';

class BookmarkMovie {
  String id;
  String poster;
  String title;
  String director;
  String average;

  BookmarkMovie(
      {required this.id,
      required this.poster,
      required this.title,
      required this.director,
      required this.average});

  Map<String, String> toMap() {
    return {
      'id': id,
      'poster': poster,
      'title': title,
      'director': director,
      'average': average,
    };
  }

  Movie toMovie() {
    return Movie(
        id: id,
        title: title,
        year: '',
        country: '',
        cast: '',
        genres: [],
        synopsis: '',
        poster: poster,
        justwatch: Justwatch(buy: [], rent: [], flatrate: []),
        director: director,
        average: average,
        reviews: []);
  }
}
