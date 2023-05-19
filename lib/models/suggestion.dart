import 'dart:convert';

import 'package:vims/models/movie.dart';
import 'package:vims/models/poster.dart';

class Suggestion extends CommonPropertiesMovie {
  final int year;
  final String country;
  final double? rating;
  final String director;

  Suggestion(
      {required id,
      required title,
      required poster,
      required this.year,
      required this.country,
      required this.rating,
      required this.director})
      : super(id: id, title: title, poster: poster);

  factory Suggestion.fromJson(String str) =>
      Suggestion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Suggestion.fromMap(Map<String, dynamic> json) => Suggestion(
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
