import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/repositories/notes_repository.dart';

class DeleteNote {
  final NotesRepository repository;

  DeleteNote(this.repository);

  Future<Either<Exception, void>> call(String id) {
    return repository.deleteNote(id);
  }
}

