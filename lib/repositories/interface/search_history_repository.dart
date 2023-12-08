abstract class SearchHistoryRepository {
  Future<List<String>> getAllSearchMoviesHistory();

  Future<List<String>> getAllSearchActorsHistory();

  Future<bool> addSearchMovieHistory(final String searchMovieHistory);

  Future<bool> addSearchActorHistory(final String searchActorHistory);

  Future removeAllSearchMoviesHistory();

  Future removeAllSearchActorsHistory();
}
