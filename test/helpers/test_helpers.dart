import 'package:mockito/annotations.dart';
import 'package:codivium_notes_app/core/database/database_helper.dart';
import 'package:codivium_notes_app/core/utils/clipboard_helper.dart';
import 'package:codivium_notes_app/features/notes/domain/repositories/notes_repository.dart';
import 'package:codivium_notes_app/features/notes/data/datasources/notes_local_datasource.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/get_all_notes.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/get_note_by_id.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/create_note.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/update_note.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/delete_note.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/toggle_favorite.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/sort_notes_by_importance.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/share_note.dart';
import 'package:codivium_notes_app/features/search/domain/repositories/search_repository.dart';
import 'package:codivium_notes_app/features/search/data/datasources/search_local_datasource.dart';
import 'package:codivium_notes_app/features/search/domain/usecases/search_notes.dart';
import 'package:codivium_notes_app/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:codivium_notes_app/features/calendar/data/datasources/calendar_local_datasource.dart';
import 'package:codivium_notes_app/features/calendar/domain/usecases/get_notes_by_date.dart';
import 'package:codivium_notes_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:codivium_notes_app/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:codivium_notes_app/features/settings/domain/usecases/toggle_theme.dart';
import 'package:codivium_notes_app/features/settings/domain/usecases/change_font.dart';

@GenerateMocks([
  DatabaseHelper,
  ClipboardHelper,
  NotesRepository,
  NotesLocalDatasource,
  GetAllNotes,
  GetNoteById,
  CreateNote,
  UpdateNote,
  DeleteNote,
  ToggleFavorite,
  SortNotesByImportance,
  ShareNote,
  SearchRepository,
  SearchLocalDatasource,
  SearchNotes,
  CalendarRepository,
  CalendarLocalDatasource,
  GetNotesByDate,
  SettingsRepository,
  SettingsLocalDatasource,
  ToggleTheme,
  ChangeFont,
])
void main() {}
