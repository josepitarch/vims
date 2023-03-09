import 'package:vims/models/movie.dart';

class BookmarkMovie {
  int id;
  String poster;
  String title;
  String director;
  double? rating;

  BookmarkMovie(
      {required this.id,
      required this.poster,
      required this.title,
      required this.director,
      this.rating});

  Map<String, dynamic> toMap() {
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
        flag: '',
        title: title,
        originalTitle: '',
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
