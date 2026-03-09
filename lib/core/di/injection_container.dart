import 'package:get_it/get_it.dart';
import 'package:codivium_notes_app/core/database/database_helper.dart';
import 'package:codivium_notes_app/features/notes/data/datasources/notes_local_datasource.dart';
import 'package:codivium_notes_app/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:codivium_notes_app/features/notes/domain/repositories/notes_repository.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/get_all_notes.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/get_note_by_id.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/create_note.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/update_note.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/delete_note.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/toggle_favorite.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/sort_notes_by_importance.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/share_note.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:codivium_notes_app/features/search/data/datasources/search_local_datasource.dart';
import 'package:codivium_notes_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:codivium_notes_app/features/search/domain/repositories/search_repository.dart';
import 'package:codivium_notes_app/features/search/domain/usecases/search_notes.dart';
import 'package:codivium_notes_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:codivium_notes_app/features/calendar/data/datasources/calendar_local_datasource.dart';
import 'package:codivium_notes_app/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:codivium_notes_app/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:codivium_notes_app/features/calendar/domain/usecases/get_notes_by_date.dart';
import 'package:codivium_notes_app/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:codivium_notes_app/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:codivium_notes_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:codivium_notes_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:codivium_notes_app/features/settings/domain/usecases/toggle_theme.dart';
import 'package:codivium_notes_app/features/settings/domain/usecases/change_font.dart';
import 'package:codivium_notes_app/features/settings/presentation/bloc/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initDatabase();
  _initNotes();
  _initSearch();
  _initCalendar();
  _initSettings();
}

Future<void> _initDatabase() async {
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
}

void _initNotes() {
  sl.registerLazySingleton<NotesLocalDatasource>(
    () => NotesLocalDatasourceImpl(databaseHelper: sl()),
  );

  sl.registerLazySingleton<NotesRepository>(
    () => NotesRepositoryImpl(localDatasource: sl()),
  );

  sl.registerLazySingleton(() => GetAllNotes(sl()));
  sl.registerLazySingleton(() => GetNoteById(sl()));
  sl.registerLazySingleton(() => CreateNote(sl()));
  sl.registerLazySingleton(() => UpdateNote(sl()));
  sl.registerLazySingleton(() => DeleteNote(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => SortNotesByImportance(sl()));
  sl.registerLazySingleton(() => ShareNote());

  sl.registerFactory(() => NotesBloc(
        getAllNotes: sl(),
        getNoteById: sl(),
        createNote: sl(),
        updateNote: sl(),
        deleteNote: sl(),
        toggleFavorite: sl(),
        sortNotesByImportance: sl(),
        shareNote: sl(),
      ));
}

void _initSearch() {
  sl.registerLazySingleton<SearchLocalDatasource>(
    () => SearchLocalDatasourceImpl(databaseHelper: sl()),
  );

  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(localDatasource: sl()),
  );

  sl.registerLazySingleton(() => SearchNotes(sl()));

  sl.registerFactory(() => SearchBloc(searchNotes: sl()));
}

void _initCalendar() {
  sl.registerLazySingleton<CalendarLocalDatasource>(
    () => CalendarLocalDatasourceImpl(databaseHelper: sl()),
  );

  sl.registerLazySingleton<CalendarRepository>(
    () => CalendarRepositoryImpl(localDatasource: sl()),
  );

  sl.registerLazySingleton(() => GetNotesByDate(sl()));

  sl.registerFactory(() => CalendarBloc(getNotesByDate: sl()));
}

void _initSettings() {
  sl.registerLazySingleton<SettingsLocalDatasource>(
    () => SettingsLocalDatasourceImpl(databaseHelper: sl()),
  );

  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDatasource: sl()),
  );

  sl.registerLazySingleton(() => ToggleTheme(sl()));
  sl.registerLazySingleton(() => ChangeFont(sl()));

  sl.registerFactory(() => SettingsBloc(
        settingsRepository: sl(),
        toggleTheme: sl(),
        changeFont: sl(),
      ));
}

