import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';

abstract class SearchRepository {
  Future<Either<Exception, List<Note>>> searchNotes(String query);
}
