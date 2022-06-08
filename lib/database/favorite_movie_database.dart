import 'package:path/path.dart';
import 'package:scrapper_filmaffinity/models/favorite_movie.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteMovieDatabase {
  static initDatabase() async {
    openDatabase(join(await getDatabasesPath(), 'favorite_movies.db'),
        onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      db.delete('favorite_movies');
      return db.execute(
        'CREATE TABLE favorite_movies(id INTEGER PRIMARY KEY, image TEXT, title TEXT, director TEXT)',
      );
    }, onUpgrade: (db, oldVersion, newVersion) {
      db.execute(
        'DROP TABLE favorite_movies',
      );
      return db.execute(
        'CREATE TABLE favorite_movies(id INTEGER PRIMARY KEY, image TEXT, title TEXT, director TEXT)',
      );
    }, version: 6);
  }

  static Future<bool> insertFavoriteMovie(FavoriteMovie movieLike) async {
    final db = await openDatabase(
        join(await getDatabasesPath(), 'favorite_movies.db'));

    await db.insert(
      'favorite_movies',
      movieLike.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    return true;
  }

  static Future<List<FavoriteMovie>> retrieveFavoriteMovies() async {
    final db = await openDatabase(
        join(await getDatabasesPath(), 'favorite_movies.db'));

    final List<Map<String, dynamic>> maps = await db.query('favorite_movies');

    return List.generate(maps.length, (i) {
      return FavoriteMovie(
        id: maps[i]['id']!.toString(),
        imageUrl: maps[i]['image']!,
        title: maps[i]['title']!,
        director: maps[i]['director']!,
      );
    });
  }
}
