import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/data/datasources/notes_local_datasource.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/domain/repositories/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDatasource localDatasource;

  NotesRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Exception, List<Note>>> getAllNotes() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, Note>> getNoteById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, void>> createNote(Note note) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, void>> updateNote(Note note) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, void>> deleteNote(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, void>> toggleFavorite(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, List<Note>>> sortByImportance() async {
    throw UnimplementedError();
  }
}

