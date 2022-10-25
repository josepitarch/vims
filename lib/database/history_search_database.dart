import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:scrapper_filmaffinity/database/querys.dart';
import 'package:logger/logger.dart';

class HistorySearchDatabase {
  static const String _databaseName = 'history_search.db';
  static const String _tableName = 'history_search';
  static initDatabase() async {
    openDatabase(join(await getDatabasesPath(), _databaseName),
        onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      db.execute(createHistorySearchTable(_tableName));
    }, onUpgrade: (db, oldVersion, newVersion) {
      db.execute(deleteHistorySearchTable(_tableName));
      db.execute(createHistorySearchTable(_tableName));
    }, version: 3);
  }

  static Future<bool> insertSearch(String search) async {
    final logger = Logger();

    final db =
        await openDatabase(join(await getDatabasesPath(), _databaseName));

    try {
      await db.insert(
        _tableName,
        {'search': search},
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      return true;
    } on DatabaseException catch (e) {
      logger.i(e.toString());
      return false;
    }
  }

  static Future<bool> deleteAllSearchs() async {
    final db =
        await openDatabase(join(await getDatabasesPath(), _databaseName));

    await db.delete(
      _tableName,
    );

    return true;
  }

  static Future<List<String>> retrieveSearchs() async {
    final db =
        await openDatabase(join(await getDatabasesPath(), _databaseName));

    final List<Map<String, dynamic>> maps =
        await db.query(_tableName, orderBy: 'id DESC', limit: 5);

    return List.generate(maps.length, (i) {
      return maps[i]['search'];
    });
  }
}
