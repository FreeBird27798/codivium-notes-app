import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/data/datasources/notes_local_datasource.dart';
import 'package:codivium_notes_app/features/notes/data/models/note_model.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/domain/repositories/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDatasource localDatasource;

  NotesRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Exception, List<Note>>> getAllNotes() async {
    try {
      final notes = await localDatasource.getAllNotes();
      return Right(notes);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Note>> getNoteById(String id) async {
    try {
      final note = await localDatasource.getNoteById(id);
      return Right(note);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> createNote(Note note) async {
    try {
      final noteModel = NoteModel(
        id: note.id,
        title: note.title,
        content: note.content,
        color: note.color,
        isFavorite: note.isFavorite,
        importance: note.importance,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
      );
      await localDatasource.createNote(noteModel);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> updateNote(Note note) async {
    try {
      final noteModel = NoteModel(
        id: note.id,
        title: note.title,
        content: note.content,
        color: note.color,
        isFavorite: note.isFavorite,
        importance: note.importance,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
      );
      await localDatasource.updateNote(noteModel);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> deleteNote(String id) async {
    try {
      await localDatasource.deleteNote(id);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> toggleFavorite(String id) async {
    try {
      await localDatasource.toggleFavorite(id);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<Note>>> sortByImportance() async {
    try {
      final notes = await localDatasource.sortByImportance();
      return Right(notes);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}

