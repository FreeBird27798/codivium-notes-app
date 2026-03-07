import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';

abstract class CalendarRepository {
  Future<Either<Exception, List<Note>>> getNotesByDate(DateTime date);
  Future<Either<Exception, List<Note>>> getNotesByDateRange(DateTime start, DateTime end);
}

