import 'dart:convert';

class Section {
  Section({
    required this.title,
    required this.code,
    required this.isRelease,
    required this.movies,
  });

  String title;
  String code;
  bool isRelease;
  List<MovieSection> movies;

  factory Section.fromJson(String str) => Section.fromMap(json.decode(str));

  factory Section.fromMap(Map<String, dynamic> json) => Section(
        title: json['title_section'],
        code: json['code'],
        isRelease: json['is_release'],
        movies: List<MovieSection>.from(
            json['films'].map((x) => MovieSection.fromMap(x))),
      );
}

class MovieSection {
  MovieSection({
    required this.id,
    required this.link,
    required this.image,
    required this.title,
    required this.premiereDay,
  });

  int id;
  String link;
  String image;
  String title;
  String premiereDay;

  factory MovieSection.fromJson(String str) =>
      MovieSection.fromMap(json.decode(str));

  factory MovieSection.fromMap(Map<String, dynamic> json) => MovieSection(
        id: json['id'],
        link: json['link'],
        image: json['poster'] ?? '',
        title: json['title'],
        premiereDay: json['premiere_day'],
      );
}
