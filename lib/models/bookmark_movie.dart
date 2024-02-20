import 'package:vims/models/movie.dart';
import 'package:vims/models/poster.dart';
import 'package:vims/models/review.dart';

class BookmarkMovie {
  final int id;
  final String poster;
  final String title;
  final String director;
  final double? rating;

  BookmarkMovie(
      {required this.id,
      required this.poster,
      required this.title,
      required this.director,
      this.rating});

  factory BookmarkMovie.fromMap(Map<String, dynamic> map) {
    return BookmarkMovie(
        id: map['movie_id'],
        poster: map['poster'],
        title: map['title'],
        director: map['director'],
        rating: map['rating']);
  }

  Map<String, dynamic> toMap() {
    return {
      'movie_id': id,
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
        year: -1,
        country: '',
        cast: [],
        genres: [],
        synopsis: '',
        poster: Poster(mtiny: poster, mmed: poster, large: poster),
        justwatch: Justwatch(buy: [], rent: [], flatrate: []),
        director: director,
        rating: rating,
        reviews: Review(critics: [], users: []));
  }
}
