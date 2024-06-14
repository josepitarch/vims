import 'dart:convert';

import 'package:vims/models/person.dart';
import 'package:vims/models/movie_suggestion.dart';

class Suggestion {
  final List<MovieSuggestion> movies;
  final List<Person> actors;

  Suggestion({required this.movies, required this.actors});

  factory Suggestion.fromJson(String str) =>
      Suggestion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Suggestion.fromMap(Map<String, dynamic> json) => Suggestion(
        movies: List<MovieSuggestion>.from(
            json['movies'].map((x) => MovieSuggestion.fromMap(x))),
        actors: List<Person>.from(json['actors'].map((x) => Person.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'movies': List<dynamic>.from(movies.map((x) => x.toMap())),
        'actors': List<dynamic>.from(actors.map((x) => x.toMap())),
      };
}
