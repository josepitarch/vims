import 'package:vims/database/bookmark_movies_database.dart';
import 'package:vims/models/bookmark_movie.dart';
import 'package:vims/models/movie.dart';
import 'package:vims/providers/interface/base_providert.dart';

final class BookmarkMoviesProvider extends BaseProvider<List<BookmarkMovie>> {
  BookmarkMoviesProvider() : super(data: [], isLoading: true);

  @override
  fetchData() async {
    BookmarkMoviesDatabase.getBookmarkMovies()
        .then((value) => data = value)
        .catchError((e) => exception = e)
        .whenComplete(() => notifyListeners());
  }

  Future<bool> insertBookmarkMovie(Movie movie) async {
    final double? rating =
        movie.rating != null ? double.parse(movie.rating.toString()) : null;

    BookmarkMovie favoriteMovie = BookmarkMovie(
        id: movie.id,
        poster: movie.poster.large,
        title: movie.title,
        director: movie.director ?? '',
        rating: rating);

    bool response =
        await BookmarkMoviesDatabase.insertBookmarkMovie(favoriteMovie);
    if (response) data.add(favoriteMovie);
    notifyListeners();

    return response;
  }

  deleteBookmarkMovie(Movie movie) async {
    bool response = await BookmarkMoviesDatabase.deleteBookmarkMovie(movie.id);
    if (response) {
      data.removeWhere((element) => element.id == movie.id);
    }
    notifyListeners();

    return response;
  }

  deleteAllBookmarkMovies() async {
    bool response = await BookmarkMoviesDatabase.deleteAllBookmarkMovies();
    if (response) data.clear();
    notifyListeners();

    return response;
  }

  @override
  onRefresh() {}
}
