String createBookmarkMovieTable(tableName) => """
    CREATE TABLE $tableName (
      id TEXT PRIMARY KEY,
      poster TEXT NOT NULL,
      title TEXT NOT NULL,
      director TEXT NOT NULL,
      average TEXT NOT NULL
    );
  """;

String createHistorySearchTable(tableName) => """
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      search TEXT NOT NULL UNIQUE
    );
    """;

String deleteBookmarkMovieTable(tableName) => "DROP TABLE $tableName";
String deleteHistorySearchTable(tableName) => "DROP TABLE $tableName";
