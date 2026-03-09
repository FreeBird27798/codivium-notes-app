import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/domain/repositories/notes_repository.dart';

class UpdateNote {
  final NotesRepository repository;

  UpdateNote(this.repository);

  Future<Either<Exception, void>> call(Note note) {
    return repository.updateNote(note);
  }
}
