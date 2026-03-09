import 'package:codivium_notes_app/core/constants/db_constants.dart';
import 'package:codivium_notes_app/core/database/database_helper.dart';
import 'package:codivium_notes_app/features/notes/data/models/note_model.dart';

abstract class CalendarLocalDatasource {
  Future<List<NoteModel>> getNotesByDate(DateTime date);
  Future<List<NoteModel>> getNotesByDateRange(DateTime start, DateTime end);
}

class CalendarLocalDatasourceImpl implements CalendarLocalDatasource {
  final DatabaseHelper databaseHelper;

  CalendarLocalDatasourceImpl({required this.databaseHelper});

  @override
  Future<List<NoteModel>> getNotesByDate(DateTime date) async {
    final db = await databaseHelper.database;
    final dateStr = date.toIso8601String().substring(0, 10);
    final result = await db.query(
      DbConstants.notesTable,
      where: '${DbConstants.columnCreatedAt} LIKE ?',
      whereArgs: ['$dateStr%'],
      orderBy: '${DbConstants.columnCreatedAt} DESC',
    );
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  @override
  Future<List<NoteModel>> getNotesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await databaseHelper.database;
    final startStr = start.toIso8601String();
    final endStr = end.toIso8601String();
    final result = await db.query(
      DbConstants.notesTable,
      where:
          '${DbConstants.columnCreatedAt} >= ? AND ${DbConstants.columnCreatedAt} <= ?',
      whereArgs: [startStr, endStr],
      orderBy: '${DbConstants.columnCreatedAt} DESC',
    );
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }
}
