import 'package:get_it/get_it.dart';
import 'package:codivium_notes_app/core/database/database_helper.dart';
import 'package:codivium_notes_app/features/notes/data/datasources/notes_local_datasource.dart';
import 'package:codivium_notes_app/features/search/data/datasources/search_local_datasource.dart';
import 'package:codivium_notes_app/features/calendar/data/datasources/calendar_local_datasource.dart';
import 'package:codivium_notes_app/features/settings/data/datasources/settings_local_datasource.dart';

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
}

void _initSearch() {
  sl.registerLazySingleton<SearchLocalDatasource>(
    () => SearchLocalDatasourceImpl(databaseHelper: sl()),
  );
}

void _initCalendar() {
  sl.registerLazySingleton<CalendarLocalDatasource>(
    () => CalendarLocalDatasourceImpl(databaseHelper: sl()),
  );
}

void _initSettings() {
  sl.registerLazySingleton<SettingsLocalDatasource>(
    () => SettingsLocalDatasourceImpl(databaseHelper: sl()),
  );
}

