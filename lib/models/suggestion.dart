import 'dart:convert';

class Suggestion {
  final int id;
  final String title;
  final String poster;

  Suggestion({
    required this.id,
    required this.title,
    required this.poster,
  });

  factory Suggestion.fromJson(String str) =>
      Suggestion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Suggestion.fromMap(Map<String, dynamic> json) => Suggestion(
        id: json["id"],
        title: json["value"].toString().trim(),
        poster: getPosterOfLabel(json["label"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "poster": poster,
      };

  static String getPosterOfLabel(String label) {
    return label
        .substring(label.indexOf('https'), label.indexOf('jpg') + 3)
        .replaceFirst('msmall', 'mmed');
  }
}
