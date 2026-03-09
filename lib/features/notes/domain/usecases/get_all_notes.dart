import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/domain/repositories/notes_repository.dart';

class GetAllNotes {
  final NotesRepository repository;

  GetAllNotes(this.repository);

  Future<Either<Exception, List<Note>>> call() {
    return repository.getAllNotes();
  }
}
