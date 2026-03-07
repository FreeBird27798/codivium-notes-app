class DbConstants {
  DbConstants._();

  static const String databaseName = 'codivium_notes.db';
  static const int databaseVersion = 1;

  static const String notesTable = 'notes';
  static const String todosTable = 'todos';
  static const String settingsTable = 'settings';

  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnContent = 'content';
  static const String columnColor = 'color';
  static const String columnIsFavorite = 'is_favorite';
  static const String columnImportance = 'importance';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  static const String columnNoteId = 'note_id';
  static const String columnTodoText = 'todo_text';
  static const String columnIsDone = 'is_done';
  static const String columnOrder = 'sort_order';
}

