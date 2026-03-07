import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/domain/repositories/notes_repository.dart';

class SortNotesByImportance {
  final NotesRepository repository;

  SortNotesByImportance(this.repository);

  Future<Either<Exception, List<Note>>> call() {
    return repository.sortByImportance();
  }
}

