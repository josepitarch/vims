class Poster {
  final String mtiny;
  final String mmed;
  final String large;

  Poster({
    required this.mtiny,
    required this.mmed,
    required this.large,
  });

  factory Poster.fromMap(Map<String, dynamic>? json) {
    if (json == null) {
      return Poster(
        mtiny: '',
        mmed: '',
        large: '',
      );
    }

    return Poster(
      mtiny: json['mtiny'],
      mmed: json['mmed'],
      large: json['large'],
    );
  }
}
