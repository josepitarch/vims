class FavoriteMovie {
  FavoriteMovie({required this.id, required this.imageUrl, required this.title, required this.director});

  String id;
  String imageUrl;
  String title;
  String director;

  Map<String, String> toMap() {
    return {
      'id': id,
      'image': imageUrl,
      'title': title,
      'director': director,
    };
  }
}
