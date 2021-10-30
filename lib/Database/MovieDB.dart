import 'package:my_movies/Model/Movie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MovieDB {
  static final MovieDB instance = MovieDB._init();
  static Database? _database;

  MovieDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('movies.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NUlL';

    await db.execute('''
    CREATE TABLE $tableMovies(
    ${MovieDetails.id} $idType,
    ${MovieDetails.name} $textType,
    ${MovieDetails.director} $textType,
    ${MovieDetails.moviePoster} $textType
    )
    ''');
  }

  Future<Movie> create(Movie movie) async {
    final db = await instance.database;
    final id = await db.insert(tableMovies, movie.toJson());
    return movie.copy(id: id);
  }

  Future<Movie> readMovies(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableMovies,
      columns: MovieDetails.values,
      where: '${MovieDetails.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Movie.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Movie>> readAllMovies() async {
    final db = await instance.database;
    final result = await db.query(tableMovies);
    return result.map((json) => Movie.fromJson(json)).toList();
  }

  Future<int> update(Movie movie) async {
    final db = await instance.database;

    return db.update(
      tableMovies,
      movie.toJson(),
      where: '${MovieDetails.id} = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableMovies,
      where: '${MovieDetails.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
