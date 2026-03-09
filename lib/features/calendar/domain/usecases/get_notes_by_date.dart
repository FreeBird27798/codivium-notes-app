import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/calendar/domain/repositories/calendar_repository.dart';

class GetNotesByDate {
  final CalendarRepository repository;

  GetNotesByDate(this.repository);

  Future<Either<Exception, List<Note>>> call(DateTime date) {
    return repository.getNotesByDate(date);
  }
}
