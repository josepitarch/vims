import 'dart:convert';

import 'package:vims/models/image.dart';

class Actor {
  final int id;
  final String name;
  final Image? image;
  final int? age;
  final String? birthday;
  final String? place;
  final List<Nacionality>? nacionalities;
  final String? flag;
  final String? height;
  final int? totalMovies;

  Actor({
    required this.id,
    required this.name,
    this.image,
    this.age,
    this.birthday,
    this.place,
    this.nacionalities,
    this.flag,
    this.height,
    required this.totalMovies,
  });

  factory Actor.fromJson(String str) => Actor.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Actor.fromMap(Map<String, dynamic> json) => Actor(
        id: json['id'],
        name: json['name'],
        image: json['image'] != null ? Image.fromMap(json['image']) : null,
        age: json['age'],
        birthday: json['birthday'],
        place: json['place'],
        nacionalities: json['nacionalities'] != null
            ? List<Nacionality>.from(
                json['nacionalities'].map((x) => Nacionality.fromMap(x)))
            : null,
        flag: json['flag'],
        height: json['height'],
        totalMovies: json['total_movies'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'image': image?.toMap(),
        'age': age,
        'birthday': birthday,
        'place': place,
        'nacionality': nacionalities,
        'flag': flag,
        'height': height,
        'total_movies': totalMovies,
      };
}

class Nacionality {
  final String name;
  final String flag;

  Nacionality({
    required this.name,
    required this.flag,
  });

  factory Nacionality.fromJson(String str) =>
      Nacionality.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Nacionality.fromMap(Map<String, dynamic> json) => Nacionality(
        name: json['name'],
        flag: json['flag'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'flag': flag,
      };
}
