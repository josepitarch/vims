import 'package:vims/models/poster.dart';

class BaseMovie {
  final int id;
  final String title;
  final Poster poster;

  BaseMovie({
    required this.id,
    required this.title,
    required this.poster,
  });

  factory BaseMovie.fromMap(Map<String, dynamic> json) => BaseMovie(
        id: json['id'],
        title: json['title'],
        poster: Poster.fromMap(json['poster']),
      );

  factory BaseMovie.origin() => BaseMovie(
      id: 0, title: '', poster: Poster(mtiny: '', mmed: '', large: ''));
}
