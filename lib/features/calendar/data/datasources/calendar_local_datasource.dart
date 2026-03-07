import 'package:codivium_notes_app/features/notes/data/models/note_model.dart';

abstract class CalendarLocalDatasource {
  Future<List<NoteModel>> getNotesByDate(DateTime date);
  Future<List<NoteModel>> getNotesByDateRange(DateTime start, DateTime end);
}

class CalendarLocalDatasourceImpl implements CalendarLocalDatasource {
  @override
  Future<List<NoteModel>> getNotesByDate(DateTime date) async {
    throw UnimplementedError();
  }

  @override
  Future<List<NoteModel>> getNotesByDateRange(DateTime start, DateTime end) async {
    throw UnimplementedError();
  }
}

