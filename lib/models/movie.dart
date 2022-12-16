import 'dart:convert' as json;

class Movie {
  final String id;
  final String flag;
  final String title;
  final String originalTitle;
  final String year;
  final String? duration;
  final String country;
  final String? director;
  final String? screenwriter;
  final String? music;
  final String? cinematography;
  final List<Actor> cast;
  final String? producer;
  final List<String> genres;
  final List<String>? groups;
  final String synopsis;
  final String poster;
  final String? rating;
  final Justwatch justwatch;
  final List<Review> reviews;
  final List<String>? platforms;
  String? heroTag;

  Movie(
      {required this.id,
      required this.flag,
      required this.title,
      required this.originalTitle,
      required this.year,
      required this.country,
      required this.cast,
      required this.genres,
      required this.synopsis,
      required this.poster,
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
      this.platforms});

  factory Movie.fromJson(String str) => Movie.fromMap(json.jsonDecode(str));

  factory Movie.fromMap(Map<String, dynamic> json) => Movie(
        id: json['id'],
        flag: json['flag'],
        title: json['title'],
        originalTitle: json['original_title'],
        year: json['year'],
        duration: json['duration'],
        country: json['country'],
        director: json['director'],
        screenwriter: json['screenwriter'],
        music: json['music'],
        cinematography: json['cinematography'],
        cast: json['cast'] == null
            ? []
            : List<Actor>.from(json['cast'].map((x) => Actor.fromMap(x))),
        producer: json['producer'],
        genres: json['genres'] == null
            ? []
            : List<String>.from(json['genres'].map((x) => x)),
        groups: json['groups'] == null
            ? []
            : List<String>.from(json['groups'].map((x) => x)),
        synopsis: json['synopsis'],
        poster: json['poster'],
        rating: json['rating'],
        justwatch: Justwatch.fromMap(json['justwatch']),
        reviews:
            List<Review>.from(json['reviews'].map((x) => Review.fromMap(x))),
      );

  factory Movie.fromIncompleteMovie(Map<String, dynamic> json) => Movie(
      id: json['id'],
      title: json['title'],
      originalTitle: json['originalTitle'] ?? json['title'],
      flag: '',
      year: json['year'] ?? '',
      country: json['country'] ?? '',
      cast: [],
      genres: [],
      synopsis: '',
      poster: json['poster'] ?? '',
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

class Actor {
  final String name;
  final String image;
  final String link;

  Actor({required this.name, required this.image, required this.link});

  factory Actor.fromMap(Map<String, dynamic> json) => Actor(
        name: json['name'],
        image: json['image'],
        link: json['link'],
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
  String url;
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
