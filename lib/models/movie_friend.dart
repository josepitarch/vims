import 'dart:convert' as json;

import 'package:vims/models/base_movie.dart';
import 'package:vims/models/poster.dart';

class MovieFriend extends BaseMovie {
  MovieFriend({required super.id, required super.title, required super.poster});

  factory MovieFriend.fromJson(String str) =>
      MovieFriend.fromMap(json.jsonDecode(str));

  factory MovieFriend.fromMap(Map<String, dynamic> json) => MovieFriend(
        id: json['id'],
        title: json['title'],
        poster: Poster.fromMap(json['poster']),
      );
}
