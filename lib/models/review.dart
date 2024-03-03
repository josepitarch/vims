import 'dart:convert' as json;
import 'package:vims/models/enums/inclination.dart';

final class Review {
  final List<CriticReview> critics;
  final List<UserReview> users;

  Review({required this.critics, required this.users});

  factory Review.fromMap(Map<String, dynamic> json) => Review(
        critics: json['critics']
            .map<CriticReview>((x) => CriticReview.fromMap(x))
            .toList()
            .cast<CriticReview>(),
        users: json['users']
            .map<UserReview>((x) => UserReview.fromMap(x))
            .toList()
            .cast<UserReview>(),
      );

  Map<String, dynamic> toMap() => {
        'critics': critics.map((x) => x.toMap()).toList(),
        'users': users.map((x) => x.toMap()).toList(),
      };
}

final class CriticReview {
  final String link;
  final String author;
  final String content;
  final Inclination inclination;

  CriticReview({
    required this.link,
    required this.author,
    required this.content,
    required this.inclination,
  });

  factory CriticReview.fromMap(Map<String, dynamic> json) => CriticReview(
        link: json['link'],
        author: json['author'],
        content: json['content'],
        inclination: Inclination.values
            .firstWhere((e) => e.name.toLowerCase() == json['inclination']),
      );

  Map<String, dynamic> toMap() => {
        'link': link,
        'author': author,
        'content': content,
        'inclination': inclination.toString(),
      };

  String toJson() => json.jsonEncode(toMap());

  factory CriticReview.fromJson(String source) =>
      CriticReview.fromMap(json.jsonDecode(source));
}

final class UserReview {
  final int id;
  final String userId;
  final int movieId;
  final String content;
  final Inclination inclination;
  final DateTime createdAt;

  UserReview({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.content,
    required this.inclination,
    required this.createdAt,
  });

  factory UserReview.fromMap(Map<String, dynamic> json) => UserReview(
        id: json['id'],
        userId: json['user_id'],
        movieId: json['movie_id'],
        content: json['content'],
        inclination: Inclination.values
            .firstWhere((e) => e.name.toLowerCase() == json['inclination']),
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toMap() => {
        'content': content,
        'inclination': inclination.name.toLowerCase(),
      };

  String toJson() => json.jsonEncode(toMap());

  factory UserReview.fromJson(String source) =>
      UserReview.fromMap(json.jsonDecode(source));
}
