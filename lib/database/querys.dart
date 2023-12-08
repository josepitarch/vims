String createBookmarkMovieTable(tableName) => """
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY,
      poster TEXT NOT NULL,
      title TEXT NOT NULL,
      director TEXT NOT NULL,
      rating REAL
    );
  """;

String createHistorySearchTable(tableName) => """
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      search TEXT NOT NULL
    );
    """;

String deleteBookmarkMovieTable(tableName) => "DROP TABLE $tableName";
String deleteHistoryMoviesSearchTable(tableName) => "DROP TABLE $tableName";
String deleteHistoryActorsSearchTable(tableName) => "DROP TABLE $tableName";
