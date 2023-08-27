import 'package:vims/models/bookmark_movie.dart';
import 'package:vims/models/movie.dart';
import 'package:vims/providers/interface/base_providert.dart';
import 'package:vims/repositories/implementation/bookmark_movies_repository.dart';
import 'package:vims/repositories/interface/bookmark_movies_repository.dart';

final class BookmarkMoviesProvider extends BaseProvider<List<BookmarkMovie>> {
  final BookmarkMoviesRepository repository = BookmarkMoviesRepositoryImpl();
  BookmarkMoviesProvider() : super(data: [], isLoading: true) {
    fetchData();
  }

  @override
  Future fetchData() async {
    repository
        .getAllBookmarkMovies()
        .then((value) => data = value)
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

    bool response = await repository.addBookmarkMovie(favoriteMovie);
    if (response) data!.add(favoriteMovie);
    notifyListeners();

    return response;
  }

  deleteBookmarkMovie(Movie movie) {
    repository
        .removeBookmarkMovie(movie.id)
        .then((value) => data!.removeWhere((element) => element.id == movie.id))
        .whenComplete(() => notifyListeners());
  }

  deleteAllBookmarkMovies() {
    repository
        .removeAllBookmarkMovies()
        .then((value) => data!.clear())
        .whenComplete(() => notifyListeners());
  }

  @override
  onRefresh() {}
}
