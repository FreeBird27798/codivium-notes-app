import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/repositories/notes_repository.dart';

class ToggleFavorite {
  final NotesRepository repository;

  ToggleFavorite(this.repository);

  Future<Either<Exception, void>> call(String id) {
    return repository.toggleFavorite(id);
  }
}
