import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vims/database/querys.dart';
import 'package:vims/repositories/interface/search_history_repository.dart';

class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  late Database _database;
  static const String _databaseName = 'history_search.db';
  static const String _tableName = 'history_search';

  SearchHistoryRepositoryImpl() {
    initDatabase();
  }

  initDatabase() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), _databaseName), onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      db.execute(createHistorySearchTable(_tableName));
    }, onUpgrade: (db, oldVersion, newVersion) {
      db.execute(deleteHistorySearchTable(_tableName));
      db.execute(createHistorySearchTable(_tableName));
    }, version: 3);
  }

  @override
  Future<bool> addSearchHistory(String searchHistory) async {
    try {
      final int response = await _database.insert(
        _tableName,
        {'search': searchHistory},
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      return response > 0;
    } on DatabaseException {
      return false;
    }
  }

  @override
  Future<List<String>> getAllSearchHistory() async {
    final List<Map<String, dynamic>> maps =
        await _database.query(_tableName, orderBy: 'id DESC', limit: 5);

    return List.generate(maps.length, (i) {
      return maps[i]['search'];
    });
  }

  @override
  Future removeAllSearchHistory() async {
    _database.delete(_tableName);
  }
}
