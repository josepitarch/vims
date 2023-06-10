import 'dart:convert' as json;

import 'package:vims/models/poster.dart';

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
  final List<Review> reviews;
  final List<String>? platforms;
  String? heroTag;

  Movie(
      {required int id,
      required String title,
      required Poster poster,
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
      this.platforms})
      : super(
          id: id,
          title: title,
          poster: poster,
        );

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
      reviews: List<Review>.from(json['reviews'].map((x) => Review.fromMap(x))),
    );
  }

  factory Movie.fromIncompleteMovie(Map<String, dynamic> json) => Movie(
      id: json['id'],
      title: json['title'],
      poster: Poster.fromMap(json['poster']),
      originalTitle: json['originalTitle'] ?? json['title'],
      flag: '',
      year: json['year'] ?? '',
      country: json['country'] ?? '',
      cast: [],
      genres: [],
      synopsis: '',
      justwatch: Justwatch(buy: [], rent: [], flatrate: []),
      director: json['director'],
      rating: json['rating'],
      reviews: [],
      platforms: json['platforms'] == null
          ? []
          : List<String>.from(json['platforms'].map((x) => x)));

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
        'reviews': List<Review>.from(reviews.map((x) => x.toMap())),
      };
}

class Cast {
  final String name;
  final String? image;
  final int id;

  Cast({required this.name, required this.image, required this.id});

  factory Cast.fromMap(Map<String, dynamic> json) => Cast(
        id: json['id'],
        name: json['name'],
        image: json['image'],
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

class Review {
  String body;
  String author;
  String inclination;
  String? reference;

  Review({
    required this.body,
    required this.author,
    required this.inclination,
    this.reference,
  });

  factory Review.fromMap(Map<String, dynamic> json) => Review(
        body: json['body'],
        author: json['author'],
        inclination: json['inclination'],
        reference: json['reference'],
      );

  Map<String, dynamic> toMap() => {
        'body': body,
        'author': author,
        'inclination': inclination,
        'reference': reference,
      };
}

class BaseMovie {
  final int id;
  final String title;
  final Poster poster;

  BaseMovie({
    required this.id,
    required this.title,
    required this.poster,
  });

  factory BaseMovie.fromMap(Map<String, dynamic> json) => BaseMovie(
        id: json['id'],
        title: json['title'],
        poster: Poster.fromMap(json['poster']),
      );

  factory BaseMovie.origin() => BaseMovie(
      id: 0, title: '', poster: Poster(mtiny: '', mmed: '', large: ''));
}
