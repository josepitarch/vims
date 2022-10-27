import 'dart:convert';

class Section {
  Section({
    required this.title,
    required this.movies,
  });

  String title;
  List<MovieSection> movies;

  factory Section.fromJson(String str) => Section.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Section.fromMap(Map<String, dynamic> json) => Section(
        title: json['title_section'],
        movies: List<MovieSection>.from(
            json['films'].map((x) => MovieSection.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'title_section': title,
        'movies': List<dynamic>.from(movies.map((x) => x.toMap())),
      };
}

class MovieSection {
  MovieSection({
    required this.id,
    required this.reference,
    required this.image,
    required this.title,
    required this.premiereDay,
  });

  String id;
  String reference;
  String image;
  String title;
  String premiereDay;

  factory MovieSection.fromJson(String str) =>
      MovieSection.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MovieSection.fromMap(Map<String, dynamic> json) => MovieSection(
        id: json['id'],
        reference: json['reference'],
        image: json['image'],
        title: json['title'],
        premiereDay: json['premiere_day'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'reference': reference,
        'image': image,
        'title': title,
        'premiere_day': premiereDay,
      };
}
