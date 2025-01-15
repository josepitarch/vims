import 'dart:convert';

import 'package:vims/models/base_movie.dart';
import 'package:vims/models/movie.dart';
import 'package:vims/models/poster.dart';

class TopMovie extends BaseMovie {
  final String director;
  final int year;
  final double rating;
  final List<Platform> platforms;

  TopMovie({
    required super.id,
    required super.title,
    required super.poster,
    required this.director,
    required this.year,
    required this.rating,
    required this.platforms,
  });

  factory TopMovie.fromJson(String str) => TopMovie.fromMap(json.decode(str));

  factory TopMovie.fromMap(Map<String, dynamic> json) => TopMovie(
        id: json['id'],
        title: json['title'],
        poster: Poster.fromMap(json['poster']),
        director: json['director'],
        year: json['year'],
        rating: double.parse(json['rating'].toString()),
        platforms: List<Platform>.from(
            json["platforms"].map((x) => Platform.fromMap(x))),
      );
}
