abstract class SearchHistoryRepository {
  Future<List<String>> getAllSearchHistory();

  Future<bool> addSearchHistory(final String searchHistory);

  Future removeAllSearchHistory();
}
