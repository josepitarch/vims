import 'dart:convert';

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
