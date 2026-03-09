import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';

abstract class NotesRepository {
  Future<Either<Exception, List<Note>>> getAllNotes();
  Future<Either<Exception, Note>> getNoteById(String id);
  Future<Either<Exception, void>> createNote(Note note);
  Future<Either<Exception, void>> updateNote(Note note);
  Future<Either<Exception, void>> deleteNote(String id);
  Future<Either<Exception, void>> toggleFavorite(String id);
  Future<Either<Exception, List<Note>>> sortByImportance();
}
