import 'package:mockito/annotations.dart';
import 'package:codivium_notes_app/core/database/database_helper.dart';
import 'package:codivium_notes_app/features/notes/domain/repositories/notes_repository.dart';
import 'package:codivium_notes_app/features/notes/data/datasources/notes_local_datasource.dart';
import 'package:codivium_notes_app/features/search/domain/repositories/search_repository.dart';
import 'package:codivium_notes_app/features/search/data/datasources/search_local_datasource.dart';
import 'package:codivium_notes_app/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:codivium_notes_app/features/calendar/data/datasources/calendar_local_datasource.dart';
import 'package:codivium_notes_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:codivium_notes_app/features/settings/data/datasources/settings_local_datasource.dart';

@GenerateMocks([
  DatabaseHelper,
  NotesRepository,
  NotesLocalDatasource,
  SearchRepository,
  SearchLocalDatasource,
  CalendarRepository,
  CalendarLocalDatasource,
  SettingsRepository,
  SettingsLocalDatasource,
])
void main() {}

