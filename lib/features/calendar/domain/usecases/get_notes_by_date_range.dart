import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/calendar/domain/repositories/calendar_repository.dart';

class GetNotesByDateRange {
  final CalendarRepository repository;

  GetNotesByDateRange(this.repository);

  Future<Either<Exception, List<Note>>> call(DateTime start, DateTime end) {
    return repository.getNotesByDateRange(start, end);
  }
}
