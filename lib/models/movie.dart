import 'dart:convert' as json;

import 'package:vims/models/base_movie.dart';
import 'package:vims/models/image.dart';
import 'package:vims/models/movie_friend.dart';
import 'package:vims/models/poster.dart';
import 'package:vims/models/review.dart';

class Movie extends BaseMovie {
  final String flag;
  final String originalTitle;
  final int year;
  final String? duration;
  final String country;
  final String? director;
  final String? screenwriter;
  final String? music;
  final String? cinematography;
  final List<Cast> cast;
  final String? producer;
  final List<String> genres;
  final List<String>? groups;
  final String synopsis;
  final double? rating;
  final Justwatch justwatch;
  final Review reviews;
  final List<String>? platforms;
  String? heroTag;

  Movie({
    required super.id,
    required super.title,
    required super.poster,
    required this.flag,
    required this.originalTitle,
    required this.year,
    required this.country,
    required this.cast,
    required this.genres,
    required this.synopsis,
    this.rating,
    required this.justwatch,
    required this.reviews,
    this.duration,
    this.director,
    this.screenwriter,
    this.music,
    this.cinematography,
    this.producer,
    this.groups,
    this.platforms,
  });

  factory Movie.fromJson(String str) => Movie.fromMap(json.jsonDecode(str));

  factory Movie.fromMap(Map<String, dynamic> json) {
    final double? rating =
        json['rating'] != null ? double.parse(json['rating'].toString()) : null;

    final List<Cast> cast = json['cast'] != null
        ? json['cast'].map((x) => Cast.fromMap(x)).toList().cast<Cast>()
        : [];

    final List<String> genres = json['genres'] != null
        ? json['genres'].map((x) => x).toList().cast<String>()
        : [];

    final List<String> groups = json['groups'] != null
        ? json['groups'].map((x) => x).toList().cast<String>()
        : [];

    return Movie(
        id: json['id'],
        title: json['title'],
        poster: Poster.fromMap(json['poster']),
        flag: json['flag'],
        originalTitle: json['original_title'],
        year: json['year'],
        duration: json['duration'],
        country: json['country'],
        director: json['director'],
        screenwriter: json['screenwriter'],
        music: json['music'],
        cinematography: json['cinematography'],
        cast: cast,
        producer: json['producer'],
        genres: genres,
        groups: groups,
        synopsis: json['synopsis'],
        rating: rating,
        justwatch: Justwatch.fromMap(json['justwatch']),
        reviews: Review.fromMap(json['reviews']));
  }
  Map<String, dynamic> toMap() => {
        'id': id,
        'year': year,
        'title': title,
        'original_title': originalTitle,
        'duration': duration,
        'country': country,
        'director': director,
        'screenwriter': screenwriter,
        'music': music,
        'cinematography': cinematography,
        'cast': cast,
        'producer': producer,
        'genres': genres,
        'synopsis': synopsis,
        'poster': poster,
        'average': rating,
        'justwatch': justwatch,
        'reviews': reviews.toMap()
      };
}

class Cast {
  final int id;
  final String name;
  final Image? image;

  Cast({required this.name, required this.image, required this.id});

  factory Cast.fromMap(Map<String, dynamic> json) => Cast(
        id: json['id'],
        name: json['name'],
        image: json['image'] != null ? Image.fromMap(json['image']) : null,
      );
}

class Justwatch {
  final List<Platform> flatrate;
  final List<Platform> rent;
  final List<Platform> buy;

  Justwatch({
    required this.flatrate,
    required this.rent,
    required this.buy,
  });

  factory Justwatch.fromMap(Map<String, dynamic> json) {
    return Justwatch(
      flatrate:
          List<Platform>.from(json['flatrate'].map((x) => Platform.fromMap(x))),
      rent: List<Platform>.from(json['rent'].map((x) => Platform.fromMap(x))),
      buy: List<Platform>.from(json['buy'].map((x) => Platform.fromMap(x))),
    );
  }

  Map<String, List<Platform>> toMap() => {
        'flatrate': List<Platform>.from(flatrate.map((x) => x)),
        'rent': List<Platform>.from(rent.map((x) => x)),
        'buy': List<Platform>.from(buy.map((x) => x)),
      };
}

class Platform {
  String name;
  String? url;
  String icon;

  Platform({
    required this.name,
    required this.url,
    required this.icon,
  });

  factory Platform.fromMap(Map<String, dynamic> json) => Platform(
        name: json['name'],
        url: json['url'],
        icon: json['icon'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'url': url,
        'icon': icon,
      };
}
