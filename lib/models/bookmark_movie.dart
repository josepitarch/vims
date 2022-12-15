import 'package:scrapper_filmaffinity/models/movie.dart';

class BookmarkMovie {
  String id;
  String poster;
  String title;
  String director;
  String? rating;

  BookmarkMovie(
      {required this.id,
      required this.poster,
      required this.title,
      required this.director,
      this.rating});

  Map<String, String> toMap() {
    return {
      'id': id,
      'poster': poster,
      'title': title,
      'director': director,
      if (rating != null) 'rating': rating!
    };
  }

  Movie toMovie() {
    return Movie(
        id: id,
        title: title,
        flag: '',
        year: '',
        country: '',
        cast: [],
        genres: [],
        synopsis: '',
        poster: poster,
        justwatch: Justwatch(buy: [], rent: [], flatrate: []),
        director: director,
        rating: rating,
        reviews: []);
  }
}
