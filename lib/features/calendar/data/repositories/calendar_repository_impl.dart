import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/calendar/data/datasources/calendar_local_datasource.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/calendar/domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarLocalDatasource localDatasource;

  CalendarRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Exception, List<Note>>> getNotesByDate(DateTime date) async {
    try {
      final notes = await localDatasource.getNotesByDate(date);
      return Right(notes);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<Note>>> getNotesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final notes = await localDatasource.getNotesByDateRange(start, end);
      return Right(notes);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
