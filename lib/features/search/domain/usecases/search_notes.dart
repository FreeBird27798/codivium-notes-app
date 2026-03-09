import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/search/domain/repositories/search_repository.dart';

class SearchNotes {
  final SearchRepository repository;

  SearchNotes(this.repository);

  Future<Either<Exception, List<Note>>> call(String query) {
    return repository.searchNotes(query);
  }
}
