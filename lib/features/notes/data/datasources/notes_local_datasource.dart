import 'package:codivium_notes_app/features/notes/data/models/note_model.dart';

abstract class NotesLocalDatasource {
  Future<List<NoteModel>> getAllNotes();
  Future<NoteModel> getNoteById(String id);
  Future<void> createNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(String id);
  Future<void> toggleFavorite(String id);
  Future<List<NoteModel>> sortByImportance();
}

class NotesLocalDatasourceImpl implements NotesLocalDatasource {
  @override
  Future<List<NoteModel>> getAllNotes() async {
    throw UnimplementedError();
  }

  @override
  Future<NoteModel> getNoteById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> createNote(NoteModel note) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNote(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> toggleFavorite(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<NoteModel>> sortByImportance() async {
    throw UnimplementedError();
  }
}

