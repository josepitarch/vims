import 'dart:convert';

class Actor {
  int id;
  String name;
  Image? image;
  String? age;
  String? birthday;
  String? place;
  String? nacionality;
  String? flag;
  String? height;
  int? totalMovies;

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
        image: Image.fromMap(json['image']),
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

  factory Image.fromMap(Map<String, dynamic> json) => Image(
        mmed: json['mmed'],
        large: json['large'],
      );

  Map<String, dynamic> toMap() => {
        'mmed': mmed,
        'large': large,
      };
}
