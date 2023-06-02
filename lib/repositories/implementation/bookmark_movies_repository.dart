import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vims/database/querys.dart';
import 'package:vims/models/bookmark_movie.dart';
import 'package:vims/repositories/interface/bookmark_movies_repository.dart';

class BookmarkMoviesRepositoryImpl implements BookmarkMoviesRepository {
  Database? _database;
  static const String _databaseName = 'bookmark_movies.db';
  static const String _tableName = 'bookmark_movies';

  BookmarkMoviesRepositoryImpl() {
    initDatabase();
  }

  initDatabase() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), _databaseName), onCreate: (db, version) {
      db.execute(createBookmarkMovieTable(_tableName));
    }, onUpgrade: (db, oldVersion, newVersion) {
      db.execute(deleteBookmarkMovieTable(_tableName));
      db.execute(createBookmarkMovieTable(_tableName));
    }, version: 8);
  }

  @override
  Future<List<BookmarkMovie>> getAllBookmarkMovies() async {
    if (_database == null) await initDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query(_tableName);

    return List.generate(maps.length, (i) {
      return BookmarkMovie(
          id: maps[i]['id'],
          poster: maps[i]['poster'],
          title: maps[i]['title'],
          director: maps[i]['director'],
          rating: maps[i]['rating']);
    });
  }

  @override
  Future<bool> addBookmarkMovie(BookmarkMovie bookmarkMovie) async {
    Map<String, dynamic> map = bookmarkMovie.toMap();

    final int response = await _database!.insert(
      _tableName,
      map,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    return response > 0;
  }

  @override
  Future<bool> removeBookmarkMovie(int id) async {
    final int response = await _database!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return response > 0;
  }

  @override
  Future removeAllBookmarkMovies() async {
    _database!.delete(_tableName);
  }
}
