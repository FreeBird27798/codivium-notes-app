import 'package:codivium_notes_app/features/notes/data/models/note_model.dart';

abstract class SearchLocalDatasource {
  Future<List<NoteModel>> searchNotes(String query);
}

class SearchLocalDatasourceImpl implements SearchLocalDatasource {
  @override
  Future<List<NoteModel>> searchNotes(String query) async {
    throw UnimplementedError();
  }
}

