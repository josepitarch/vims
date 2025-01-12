import 'dart:convert' as json;

import 'package:vims/models/base_movie.dart';
import 'package:vims/models/poster.dart';

class ActorMovie extends BaseMovie {
  final String director;
  final String country;
  final String flag;
  final int year;

  ActorMovie(
      {required super.id,
      required super.title,
      required super.poster,
      required this.director,
      required this.country,
      required this.flag,
      required this.year});

  factory ActorMovie.fromJson(String str) =>
      ActorMovie.fromMap(json.jsonDecode(str));

  factory ActorMovie.fromMap(Map<String, dynamic> json) => ActorMovie(
        id: json['id'],
        title: json['title'],
        poster: Poster.fromMap(json['poster']),
        director: json['director'],
        country: json['country'],
        flag: json['flag'],
        year: json['year'],
      );
}
