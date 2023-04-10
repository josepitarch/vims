import 'dart:convert';

class Suggestion {
  final int id;
  final String title;
  final String poster;
  final String? year;
  final String? country;
  final double? rating;
  final String? director;

  Suggestion(
      {required this.id,
      required this.title,
      required this.poster,
      this.year,
      this.country,
      this.rating,
      this.director});

  factory Suggestion.fromJson(String str) =>
      Suggestion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Suggestion.fromMap(Map<String, dynamic> json) => Suggestion(
        id: json["id"],
        title: json["title"],
        poster: json["poster"],
        year: json["year"],
        country: json["country"],
        rating: json["rating"]?.toDouble(),
        director: json["director"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "poster": poster,
        "year": year,
        "country": country,
        "rating": rating,
        "director": director,
      };
}
