import 'dart:convert';

import 'package:vims/models/base_movie.dart';
import 'package:vims/models/poster.dart';

class MovieSuggestion extends BaseMovie {
  final int? year;
  final String? country;
  final double? rating;
  final String? director;

  MovieSuggestion(
      {required super.id,
      required super.title,
      required super.poster,
      required this.year,
      required this.country,
      required this.rating,
      required this.director});

  factory MovieSuggestion.fromJson(String str) =>
      MovieSuggestion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MovieSuggestion.fromMap(Map<String, dynamic> json) => MovieSuggestion(
        id: json['id'],
        title: json['title'],
        poster: Poster.fromMap(json['poster']),
        year: json['year'],
        country: json['country'],
        rating: json['rating']?.toDouble(),
        director: json['director'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'poster': poster,
        'year': year,
        'country': country,
        'rating': rating,
        'director': director,
      };
}
