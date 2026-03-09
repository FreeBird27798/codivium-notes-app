import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/domain/repositories/notes_repository.dart';

class GetNoteById {
  final NotesRepository repository;

  GetNoteById(this.repository);

  Future<Either<Exception, Note>> call(String id) {
    return repository.getNoteById(id);
  }
}
