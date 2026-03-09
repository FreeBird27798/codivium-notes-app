import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:codivium_notes_app/core/constants/db_constants.dart';

Future<Database> createTestDatabase() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final db = await openDatabase(
    inMemoryDatabasePath,
    version: DbConstants.databaseVersion,
    onCreate: (db, version) async {
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
    },
  );

  return db;
}

void main() {
  late Database db;

  setUp(() async {
    db = await createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  group('Database Creation', () {
    test('should create the notes table', () async {
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [DbConstants.notesTable],
      );
      expect(result.length, 1);
      expect(result.first['name'], DbConstants.notesTable);
    });

    test('should create the todos table', () async {
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [DbConstants.todosTable],
      );
      expect(result.length, 1);
      expect(result.first['name'], DbConstants.todosTable);
    });

    test('should create the settings table', () async {
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [DbConstants.settingsTable],
      );
      expect(result.length, 1);
      expect(result.first['name'], DbConstants.settingsTable);
    });
  });

  group('Notes Table', () {
    test('should insert a note', () async {
      final now = DateTime.now().toIso8601String();
      await db.insert(DbConstants.notesTable, {
        DbConstants.columnId: 'note_1',
        DbConstants.columnTitle: 'Test Note',
        DbConstants.columnContent: 'Test Content',
        DbConstants.columnColor: 0xFFFF0000,
        DbConstants.columnIsFavorite: 0,
        DbConstants.columnImportance: 1,
        DbConstants.columnCreatedAt: now,
        DbConstants.columnUpdatedAt: now,
      });

      final result = await db.query(DbConstants.notesTable);
      expect(result.length, 1);
      expect(result.first[DbConstants.columnTitle], 'Test Note');
    });

    test('should query a note by id', () async {
      final now = DateTime.now().toIso8601String();
      await db.insert(DbConstants.notesTable, {
        DbConstants.columnId: 'note_1',
        DbConstants.columnTitle: 'Test Note',
        DbConstants.columnContent: 'Test Content',
        DbConstants.columnColor: 0xFFFF0000,
        DbConstants.columnIsFavorite: 0,
        DbConstants.columnImportance: 1,
        DbConstants.columnCreatedAt: now,
        DbConstants.columnUpdatedAt: now,
      });

      final result = await db.query(
        DbConstants.notesTable,
        where: '${DbConstants.columnId} = ?',
        whereArgs: ['note_1'],
      );
      expect(result.length, 1);
      expect(result.first[DbConstants.columnId], 'note_1');
    });

    test('should update a note', () async {
      final now = DateTime.now().toIso8601String();
      await db.insert(DbConstants.notesTable, {
        DbConstants.columnId: 'note_1',
        DbConstants.columnTitle: 'Old Title',
        DbConstants.columnContent: 'Content',
        DbConstants.columnColor: 0xFFFF0000,
        DbConstants.columnIsFavorite: 0,
        DbConstants.columnImportance: 1,
        DbConstants.columnCreatedAt: now,
        DbConstants.columnUpdatedAt: now,
      });

      await db.update(
        DbConstants.notesTable,
        {DbConstants.columnTitle: 'New Title'},
        where: '${DbConstants.columnId} = ?',
        whereArgs: ['note_1'],
      );

      final result = await db.query(
        DbConstants.notesTable,
        where: '${DbConstants.columnId} = ?',
        whereArgs: ['note_1'],
      );
      expect(result.first[DbConstants.columnTitle], 'New Title');
    });

    test('should delete a note', () async {
      final now = DateTime.now().toIso8601String();
      await db.insert(DbConstants.notesTable, {
        DbConstants.columnId: 'note_1',
        DbConstants.columnTitle: 'Test Note',
        DbConstants.columnContent: 'Content',
        DbConstants.columnColor: 0xFFFF0000,
        DbConstants.columnIsFavorite: 0,
        DbConstants.columnImportance: 1,
        DbConstants.columnCreatedAt: now,
        DbConstants.columnUpdatedAt: now,
      });

      await db.delete(
        DbConstants.notesTable,
        where: '${DbConstants.columnId} = ?',
        whereArgs: ['note_1'],
      );

      final result = await db.query(DbConstants.notesTable);
      expect(result.length, 0);
    });

    test('should toggle favorite', () async {
      final now = DateTime.now().toIso8601String();
      await db.insert(DbConstants.notesTable, {
        DbConstants.columnId: 'note_1',
        DbConstants.columnTitle: 'Test Note',
        DbConstants.columnContent: 'Content',
        DbConstants.columnColor: 0xFFFF0000,
        DbConstants.columnIsFavorite: 0,
        DbConstants.columnImportance: 1,
        DbConstants.columnCreatedAt: now,
        DbConstants.columnUpdatedAt: now,
      });

      await db.update(
        DbConstants.notesTable,
        {DbConstants.columnIsFavorite: 1},
        where: '${DbConstants.columnId} = ?',
        whereArgs: ['note_1'],
      );

      final result = await db.query(
        DbConstants.notesTable,
        where: '${DbConstants.columnId} = ?',
        whereArgs: ['note_1'],
      );
      expect(result.first[DbConstants.columnIsFavorite], 1);
    });
  });

  group('Todos Table', () {
    test('should insert a todo', () async {
      final now = DateTime.now().toIso8601String();
      await db.insert(DbConstants.notesTable, {
        DbConstants.columnId: 'note_1',
        DbConstants.columnTitle: 'Test',
        DbConstants.columnContent: 'Content',
        DbConstants.columnColor: 0xFFFF0000,
        DbConstants.columnIsFavorite: 0,
        DbConstants.columnImportance: 0,
        DbConstants.columnCreatedAt: now,
        DbConstants.columnUpdatedAt: now,
      });

      await db.insert(DbConstants.todosTable, {
        DbConstants.columnId: 'todo_1',
        DbConstants.columnNoteId: 'note_1',
        DbConstants.columnTodoText: 'Buy milk',
        DbConstants.columnIsDone: 0,
        DbConstants.columnOrder: 0,
      });

      final result = await db.query(DbConstants.todosTable);
      expect(result.length, 1);
      expect(result.first[DbConstants.columnTodoText], 'Buy milk');
    });

    test('should query todos by note id', () async {
      final now = DateTime.now().toIso8601String();
      await db.insert(DbConstants.notesTable, {
        DbConstants.columnId: 'note_1',
        DbConstants.columnTitle: 'Test',
        DbConstants.columnContent: 'Content',
        DbConstants.columnColor: 0xFFFF0000,
        DbConstants.columnIsFavorite: 0,
        DbConstants.columnImportance: 0,
        DbConstants.columnCreatedAt: now,
        DbConstants.columnUpdatedAt: now,
      });

      await db.insert(DbConstants.todosTable, {
        DbConstants.columnId: 'todo_1',
        DbConstants.columnNoteId: 'note_1',
        DbConstants.columnTodoText: 'Task 1',
        DbConstants.columnIsDone: 0,
        DbConstants.columnOrder: 0,
      });

      await db.insert(DbConstants.todosTable, {
        DbConstants.columnId: 'todo_2',
        DbConstants.columnNoteId: 'note_1',
        DbConstants.columnTodoText: 'Task 2',
        DbConstants.columnIsDone: 1,
        DbConstants.columnOrder: 1,
      });

      final result = await db.query(
        DbConstants.todosTable,
        where: '${DbConstants.columnNoteId} = ?',
        whereArgs: ['note_1'],
        orderBy: '${DbConstants.columnOrder} ASC',
      );
      expect(result.length, 2);
      expect(result.first[DbConstants.columnTodoText], 'Task 1');
      expect(result.last[DbConstants.columnTodoText], 'Task 2');
    });

    test('should update a todo', () async {
      final now = DateTime.now().toIso8601String();
      await db.insert(DbConstants.notesTable, {
        DbConstants.columnId: 'note_1',
        DbConstants.columnTitle: 'Test',
        DbConstants.columnContent: 'Content',
        DbConstants.columnColor: 0xFFFF0000,
        DbConstants.columnIsFavorite: 0,
        DbConstants.columnImportance: 0,
        DbConstants.columnCreatedAt: now,
        DbConstants.columnUpdatedAt: now,
      });

      await db.insert(DbConstants.todosTable, {
        DbConstants.columnId: 'todo_1',
        DbConstants.columnNoteId: 'note_1',
        DbConstants.columnTodoText: 'Old task',
        DbConstants.columnIsDone: 0,
        DbConstants.columnOrder: 0,
      });

      await db.update(
        DbConstants.todosTable,
        {DbConstants.columnIsDone: 1},
        where: '${DbConstants.columnId} = ?',
        whereArgs: ['todo_1'],
      );

      final result = await db.query(
        DbConstants.todosTable,
        where: '${DbConstants.columnId} = ?',
        whereArgs: ['todo_1'],
      );
      expect(result.first[DbConstants.columnIsDone], 1);
    });

    test('should delete a todo', () async {
      final now = DateTime.now().toIso8601String();
      await db.insert(DbConstants.notesTable, {
        DbConstants.columnId: 'note_1',
        DbConstants.columnTitle: 'Test',
        DbConstants.columnContent: 'Content',
        DbConstants.columnColor: 0xFFFF0000,
        DbConstants.columnIsFavorite: 0,
        DbConstants.columnImportance: 0,
        DbConstants.columnCreatedAt: now,
        DbConstants.columnUpdatedAt: now,
      });

      await db.insert(DbConstants.todosTable, {
        DbConstants.columnId: 'todo_1',
        DbConstants.columnNoteId: 'note_1',
        DbConstants.columnTodoText: 'Task',
        DbConstants.columnIsDone: 0,
        DbConstants.columnOrder: 0,
      });

      await db.delete(
        DbConstants.todosTable,
        where: '${DbConstants.columnId} = ?',
        whereArgs: ['todo_1'],
      );

      final result = await db.query(DbConstants.todosTable);
      expect(result.length, 0);
    });
  });

  group('Settings Table', () {
    test('should insert a setting', () async {
      await db.insert(DbConstants.settingsTable, {
        DbConstants.columnId: 'setting_1',
        'key': 'is_dark_mode',
        'value': 'true',
      });

      final result = await db.query(DbConstants.settingsTable);
      expect(result.length, 1);
      expect(result.first['key'], 'is_dark_mode');
      expect(result.first['value'], 'true');
    });

    test('should update a setting', () async {
      await db.insert(DbConstants.settingsTable, {
        DbConstants.columnId: 'setting_1',
        'key': 'is_dark_mode',
        'value': 'false',
      });

      await db.update(
        DbConstants.settingsTable,
        {'value': 'true'},
        where: 'key = ?',
        whereArgs: ['is_dark_mode'],
      );

      final result = await db.query(
        DbConstants.settingsTable,
        where: 'key = ?',
        whereArgs: ['is_dark_mode'],
      );
      expect(result.first['value'], 'true');
    });

    test('should query a setting by key', () async {
      await db.insert(DbConstants.settingsTable, {
        DbConstants.columnId: 'setting_1',
        'key': 'font_family',
        'value': 'Roboto',
      });

      final result = await db.query(
        DbConstants.settingsTable,
        where: 'key = ?',
        whereArgs: ['font_family'],
      );
      expect(result.length, 1);
      expect(result.first['value'], 'Roboto');
    });

    test('should return empty when setting does not exist', () async {
      final result = await db.query(
        DbConstants.settingsTable,
        where: 'key = ?',
        whereArgs: ['nonexistent'],
      );
      expect(result.length, 0);
    });
  });
}

