import 'dart:convert';

import 'package:vims/models/movie.dart';
import 'package:vims/models/poster.dart';

class Section {
  final String id;
  final String title;
  final String? icon;
  final List<MovieSection> movies;

  Section({
    required this.id,
    required this.title,
    this.icon,
    required this.movies,
  });

  factory Section.fromJson(String str) => Section.fromMap(json.decode(str));

  factory Section.fromMap(Map<String, dynamic> json) => Section(
        id: json['id'],
        title: json['title'],
        icon: json['icon'],
        movies: List<MovieSection>.from(
            json['movies'].map((x) => MovieSection.fromMap(x))),
      );
}

class MovieSection extends BaseMovie {
  MovieSection(
      {required super.id, required super.title, required super.poster});

  factory MovieSection.fromJson(String str) =>
      MovieSection.fromMap(json.decode(str));

  factory MovieSection.fromMap(Map<String, dynamic> json) => MovieSection(
      id: json['id'],
      title: json['title'],
      poster: Poster.fromMap(json['poster']));
}
