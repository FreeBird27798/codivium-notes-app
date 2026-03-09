import 'package:codivium_notes_app/core/constants/db_constants.dart';
import 'package:codivium_notes_app/core/database/database_helper.dart';
import 'package:codivium_notes_app/features/notes/data/models/note_model.dart';
import 'package:codivium_notes_app/features/notes/data/models/todo_model.dart';

abstract class NotesLocalDatasource {
  Future<List<NoteModel>> getAllNotes();
  Future<NoteModel> getNoteById(String id);
  Future<void> createNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(String id);
  Future<void> toggleFavorite(String id);
  Future<List<NoteModel>> sortByImportance();
  Future<List<TodoModel>> getTodosForNote(String noteId);
  Future<void> insertTodo(TodoModel todo);
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String todoId);
}

class NotesLocalDatasourceImpl implements NotesLocalDatasource {
  final DatabaseHelper databaseHelper;

  NotesLocalDatasourceImpl({required this.databaseHelper});

  @override
  Future<List<NoteModel>> getAllNotes() async {
    final db = await databaseHelper.database;
    final result = await db.query(
      DbConstants.notesTable,
      orderBy: '${DbConstants.columnUpdatedAt} DESC',
    );
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  @override
  Future<NoteModel> getNoteById(String id) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      DbConstants.notesTable,
      where: '${DbConstants.columnId} = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) {
      throw Exception('Note not found');
    }
    return NoteModel.fromMap(result.first);
  }

  @override
  Future<void> createNote(NoteModel note) async {
    final db = await databaseHelper.database;
    await db.insert(DbConstants.notesTable, note.toMap());
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    final db = await databaseHelper.database;
    await db.update(
      DbConstants.notesTable,
      note.toMap(),
      where: '${DbConstants.columnId} = ?',
      whereArgs: [note.id],
    );
  }

  @override
  Future<void> deleteNote(String id) async {
    final db = await databaseHelper.database;
    await db.delete(
      DbConstants.todosTable,
      where: '${DbConstants.columnNoteId} = ?',
      whereArgs: [id],
    );
    await db.delete(
      DbConstants.notesTable,
      where: '${DbConstants.columnId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> toggleFavorite(String id) async {
    final db = await databaseHelper.database;
    final note = await getNoteById(id);
    final newValue = note.isFavorite ? 0 : 1;
    await db.update(
      DbConstants.notesTable,
      {DbConstants.columnIsFavorite: newValue},
      where: '${DbConstants.columnId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<NoteModel>> sortByImportance() async {
    final db = await databaseHelper.database;
    final result = await db.query(
      DbConstants.notesTable,
      orderBy: '${DbConstants.columnImportance} DESC',
    );
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  @override
  Future<List<TodoModel>> getTodosForNote(String noteId) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      DbConstants.todosTable,
      where: '${DbConstants.columnNoteId} = ?',
      whereArgs: [noteId],
      orderBy: '${DbConstants.columnOrder} ASC',
    );
    return result.map((map) => TodoModel.fromMap(map)).toList();
  }

  @override
  Future<void> insertTodo(TodoModel todo) async {
    final db = await databaseHelper.database;
    await db.insert(DbConstants.todosTable, todo.toMap());
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    final db = await databaseHelper.database;
    await db.update(
      DbConstants.todosTable,
      todo.toMap(),
      where: '${DbConstants.columnId} = ?',
      whereArgs: [todo.id],
    );
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    final db = await databaseHelper.database;
    await db.delete(
      DbConstants.todosTable,
      where: '${DbConstants.columnId} = ?',
      whereArgs: [todoId],
    );
  }
}

