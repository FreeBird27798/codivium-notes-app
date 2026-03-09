import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:codivium_notes_app/core/constants/db_constants.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DbConstants.databaseName);

    return await openDatabase(
      path,
      version: DbConstants.databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DbConstants.notesTable} (
        ${DbConstants.columnId} TEXT PRIMARY KEY,
        ${DbConstants.columnTitle} TEXT NOT NULL,
        ${DbConstants.columnContent} TEXT NOT NULL,
        ${DbConstants.columnColor} INTEGER NOT NULL,
        ${DbConstants.columnIsFavorite} INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.columnImportance} INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.columnCreatedAt} TEXT NOT NULL,
        ${DbConstants.columnUpdatedAt} TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.todosTable} (
        ${DbConstants.columnId} TEXT PRIMARY KEY,
        ${DbConstants.columnNoteId} TEXT NOT NULL,
        ${DbConstants.columnTodoText} TEXT NOT NULL,
        ${DbConstants.columnIsDone} INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.columnOrder} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (${DbConstants.columnNoteId}) REFERENCES ${DbConstants.notesTable} (${DbConstants.columnId}) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.settingsTable} (
        ${DbConstants.columnId} TEXT PRIMARY KEY,
        key TEXT NOT NULL,
        value TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }
}

