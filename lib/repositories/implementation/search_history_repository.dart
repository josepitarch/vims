import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vims/database/querys.dart';
import 'package:vims/repositories/interface/search_history_repository.dart';

class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  late Database _database;
  static const String _databaseName = 'history_search.db';
  static const String _moviesTable = 'movies_history_search';
  static const String _actorsTable = 'actors_history_search';
  static const int _version = 5;

  SearchHistoryRepositoryImpl() {
    initDatabase();
  }

  initDatabase() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), _databaseName), onCreate: (db, version) {
      db.execute(createHistorySearchTable(_moviesTable));
      db.execute(createHistorySearchTable(_actorsTable));
    }, onUpgrade: (db, oldVersion, newVersion) {
      db.execute("ALTER TABLE history_search RENAME TO movies_history_search;");
      db.execute(createHistorySearchTable(_actorsTable));
    }, version: _version);
  }

  @override
  Future<bool> addSearchMovieHistory(String searchMovieHistory) async {
    return await addSearchHistory(searchMovieHistory, _moviesTable);
  }

  @override
  Future<bool> addSearchActorHistory(String searchActorHistory) async {
    return await addSearchHistory(searchActorHistory, _actorsTable);
  }

  @override
  Future<List<String>> getAllSearchMoviesHistory() async {
    return await getAllSearchHistory(_moviesTable);
  }

  @override
  Future<List<String>> getAllSearchActorsHistory() async {
    return await getAllSearchHistory(_actorsTable);
  }

  Future<List<String>> getAllSearchHistory(String table) async {
    final List<Map<String, dynamic>> maps =
        await _database.query(table, orderBy: 'id DESC', limit: 5);

    return List.generate(maps.length, (i) {
      return maps[i]['search'];
    });
  }

  Future<bool> addSearchHistory(String history, String table) async {
    try {
      final int response = await _database.insert(
        table,
        {'search': history},
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      return response > 0;
    } on DatabaseException {
      return false;
    }
  }

  @override
  Future removeAllSearchMoviesHistory() async {
    _database.delete(_moviesTable);
  }

  @override
  Future removeAllSearchActorsHistory() async {
    _database.delete(_actorsTable);
  }
}
