import 'dart:convert';

import 'package:vims/models/movie.dart';
import 'package:vims/models/poster.dart';

class Section {
  String id;
  String title;
  List<MovieSection> movies;

  Section({
    required this.id,
    required this.title,
    required this.movies,
  });

  factory Section.fromJson(String str) => Section.fromMap(json.decode(str));

  factory Section.fromMap(Map<String, dynamic> json) => Section(
        id: json['id'],
        title: json['title'],
        movies: List<MovieSection>.from(
            json['movies'].map((x) => MovieSection.fromMap(x))),
      );
}

class MovieSection extends BaseMovie {
  final String premiereDay;

  MovieSection({
    required id,
    required title,
    required poster,
    required this.premiereDay,
  }) : super(
          id: id,
          title: title,
          poster: poster,
        );

  factory MovieSection.fromJson(String str) =>
      MovieSection.fromMap(json.decode(str));

  factory MovieSection.fromMap(Map<String, dynamic> json) => MovieSection(
        id: json['id'],
        title: json['title'],
        poster: Poster.fromMap(json['poster']),
        premiereDay: json['premiere_day'],
      );
}
