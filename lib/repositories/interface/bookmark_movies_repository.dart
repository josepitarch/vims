import 'package:vims/models/bookmark_movie.dart';

abstract class BookmarkMoviesRepository {
  Future<List<BookmarkMovie>> getAllBookmarkMovies();

  Future<bool> addBookmarkMovie(final BookmarkMovie movie);

  Future removeAllBookmarkMovies();

  Future removeBookmarkMovie(final int id);
}
