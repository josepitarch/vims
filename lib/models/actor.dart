import 'dart:convert';

class Actor {
  final int id;
  final String name;
  final Image? image;
  final String? age;
  final String? birthday;
  final String? place;
  final String? nacionality;
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
    this.nacionality,
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
        nacionality: json['nacionality'],
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
        'nacionality': nacionality,
        'flag': flag,
        'height': height,
        'total_movies': totalMovies,
      };
}

class Image {
  String mmed;
  String large;

  Image({
    required this.mmed,
    required this.large,
  });

  factory Image.fromJson(String str) => Image.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Image.fromMap(Map<String, dynamic> json) {
    return Image(
      mmed: json['mmed'],
      large: json['large'],
    );
  }

  Map<String, dynamic> toMap() => {
        'mmed': mmed,
        'large': large,
      };
}
