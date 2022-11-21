import 'package:path/path.dart';
import 'package:scrapper_filmaffinity/database/querys.dart';
import 'package:scrapper_filmaffinity/models/favorite_movie.dart';
import 'package:sqflite/sqflite.dart';

class BookmarkMoviesDatabase {
  static const String _databaseName = 'bookmark_movies.db';
  static const String _tableName = 'bookmark_movies';

  static initDatabase() async {
    openDatabase(join(await getDatabasesPath(), _databaseName),
        onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      db.execute(createBookmarkMovieTable(_tableName));
    }, onUpgrade: (db, oldVersion, newVersion) {
      db.execute(deleteBookmarkMovieTable(_tableName));
      db.execute(createBookmarkMovieTable(_tableName));
    }, version: 8);
  }

  static Future<bool> insertBookmarkMovie(BookmarkMovie bookmarkMovie) async {
    final db =
        await openDatabase(join(await getDatabasesPath(), _databaseName));

    int response = await db.insert(
      _tableName,
      bookmarkMovie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    return response == 0 ? false : true;
  }

  static Future<bool> deleteBookmarkMovie(String id) async {
    final db =
        await openDatabase(join(await getDatabasesPath(), _databaseName));

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return true;
  }

  static Future<bool> deleteAllBookmarkMovies() async {
    final db =
        await openDatabase(join(await getDatabasesPath(), _databaseName));

    await db.delete(
      _tableName,
    );

    return true;
  }

  static Future<List<BookmarkMovie>> getBookmarkMovies() async {
    final db =
        await openDatabase(join(await getDatabasesPath(), _databaseName));

    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return BookmarkMovie(
          id: maps[i]['id'],
          poster: maps[i]['poster'],
          title: maps[i]['title'],
          director: maps[i]['director'],
          average: maps[i]['average']);
    });
  }
}
