import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:codivium_notes_app/features/notes/data/datasources/notes_local_datasource.dart';
import 'package:codivium_notes_app/features/notes/data/models/note_model.dart';
import 'package:codivium_notes_app/features/notes/data/models/todo_model.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late MockDatabaseHelper mockDatabaseHelper;
  late NotesLocalDatasourceImpl datasource;
  late Database db;

  setUp(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    db = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            color INTEGER NOT NULL,
            is_favorite INTEGER NOT NULL DEFAULT 0,
            importance INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE todos (
            id TEXT PRIMARY KEY,
            note_id TEXT NOT NULL,
            todo_text TEXT NOT NULL,
            is_done INTEGER NOT NULL DEFAULT 0,
            sort_order INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY (note_id) REFERENCES notes (id) ON DELETE CASCADE
          )
        ''');
      },
    );

    mockDatabaseHelper = MockDatabaseHelper();
    when(mockDatabaseHelper.database).thenAnswer((_) async => db);
    datasource = NotesLocalDatasourceImpl(databaseHelper: mockDatabaseHelper);
  });

  tearDown(() async {
    await db.close();
  });

  final now = DateTime(2026, 1, 1);
  final testNote = NoteModel(
    id: 'note_1',
    title: 'Test Note',
    content: 'Test Content',
    color: 0xFFFF0000,
    isFavorite: false,
    importance: 1,
    createdAt: now,
    updatedAt: now,
  );

  final testTodo = TodoModel(
    id: 'todo_1',
    noteId: 'note_1',
    text: 'Buy milk',
    isDone: false,
    order: 0,
  );

  group('NotesLocalDatasource', () {
    test('should return list of NoteModel when getAllNotes is called', () async {
      await db.insert('notes', testNote.toMap());

      final result = await datasource.getAllNotes();

      expect(result.length, 1);
      expect(result.first.id, 'note_1');
      expect(result.first.title, 'Test Note');
    });

    test('should return NoteModel when getNoteById is called', () async {
      await db.insert('notes', testNote.toMap());

      final result = await datasource.getNoteById('note_1');

      expect(result.id, 'note_1');
      expect(result.title, 'Test Note');
    });

    test('should throw when getNoteById is called with wrong id', () async {
      expect(
        () => datasource.getNoteById('wrong_id'),
        throwsA(isA<Exception>()),
      );
    });

    test('should call insert when createNote is called', () async {
      await datasource.createNote(testNote);

      final result = await db.query('notes');
      expect(result.length, 1);
      expect(result.first['title'], 'Test Note');
    });

    test('should call update when updateNote is called', () async {
      await db.insert('notes', testNote.toMap());

      final updated = NoteModel(
        id: 'note_1',
        title: 'Updated Title',
        content: 'Updated Content',
        color: 0xFFFF0000,
        isFavorite: false,
        importance: 1,
        createdAt: now,
        updatedAt: now,
      );

      await datasource.updateNote(updated);

      final result = await db.query('notes', where: 'id = ?', whereArgs: ['note_1']);
      expect(result.first['title'], 'Updated Title');
    });

    test('should call delete when deleteNote is called', () async {
      await db.insert('notes', testNote.toMap());

      await datasource.deleteNote('note_1');

      final result = await db.query('notes');
      expect(result.length, 0);
    });

    test('should toggle favorite from false to true', () async {
      await db.insert('notes', testNote.toMap());

      await datasource.toggleFavorite('note_1');

      final result = await db.query('notes', where: 'id = ?', whereArgs: ['note_1']);
      expect(result.first['is_favorite'], 1);
    });

    test('should return notes sorted by importance', () async {
      await db.insert('notes', testNote.toMap());

      final note2 = NoteModel(
        id: 'note_2',
        title: 'Important Note',
        content: 'Content',
        color: 0xFF00FF00,
        isFavorite: false,
        importance: 5,
        createdAt: now,
        updatedAt: now,
      );
      await db.insert('notes', note2.toMap());

      final result = await datasource.sortByImportance();

      expect(result.length, 2);
      expect(result.first.importance, 5);
      expect(result.last.importance, 1);
    });

    test('should return todos for a note', () async {
      await db.insert('notes', testNote.toMap());
      await db.insert('todos', testTodo.toMap());

      final result = await datasource.getTodosForNote('note_1');

      expect(result.length, 1);
      expect(result.first.text, 'Buy milk');
    });

    test('should insert a todo', () async {
      await db.insert('notes', testNote.toMap());

      await datasource.insertTodo(testTodo);

      final result = await db.query('todos');
      expect(result.length, 1);
    });

    test('should update a todo', () async {
      await db.insert('notes', testNote.toMap());
      await db.insert('todos', testTodo.toMap());

      final updated = TodoModel(
        id: 'todo_1',
        noteId: 'note_1',
        text: 'Buy eggs',
        isDone: true,
        order: 0,
      );

      await datasource.updateTodo(updated);

      final result = await db.query('todos', where: 'id = ?', whereArgs: ['todo_1']);
      expect(result.first['todo_text'], 'Buy eggs');
      expect(result.first['is_done'], 1);
    });

    test('should delete a todo', () async {
      await db.insert('notes', testNote.toMap());
      await db.insert('todos', testTodo.toMap());

      await datasource.deleteTodo('todo_1');

      final result = await db.query('todos');
      expect(result.length, 0);
    });
  });
}

