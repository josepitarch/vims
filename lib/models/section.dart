import 'dart:convert';

class Section {
  Section({
    required this.title,
    required this.films,
  });

  String title;
  List<Film> films;

  factory Section.fromJson(String str) => Section.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Section.fromMap(Map<String, dynamic> json) => Section(
        title: json['title_section'],
        films: List<Film>.from(json['films'].map((x) => Film.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'title_section': title,
        'films': List<dynamic>.from(films.map((x) => x.toMap())),
      };
}

class Film {
  Film({
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

  factory Film.fromJson(String str) => Film.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Film.fromMap(Map<String, dynamic> json) => Film(
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
