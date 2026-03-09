import 'package:codivium_notes_app/core/constants/db_constants.dart';
import 'package:codivium_notes_app/core/database/database_helper.dart';
import 'package:codivium_notes_app/features/notes/data/models/note_model.dart';

abstract class SearchLocalDatasource {
  Future<List<NoteModel>> searchNotes(String query);
}

class SearchLocalDatasourceImpl implements SearchLocalDatasource {
  final DatabaseHelper databaseHelper;

  SearchLocalDatasourceImpl({required this.databaseHelper});

  @override
  Future<List<NoteModel>> searchNotes(String query) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      DbConstants.notesTable,
      where:
          '${DbConstants.columnTitle} LIKE ? OR ${DbConstants.columnContent} LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: '${DbConstants.columnUpdatedAt} DESC',
    );
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }
}
