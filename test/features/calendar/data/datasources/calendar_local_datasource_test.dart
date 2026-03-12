import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:codivium_notes_app/features/calendar/data/datasources/calendar_local_datasource.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late MockDatabaseHelper mockDatabaseHelper;
  late CalendarLocalDatasourceImpl datasource;
  late Database db;

  setUp(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    db = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            color INTEGER NOT NULL,
            is_favorite INTEGER NOT NULL DEFAULT 0,
            importance INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
      },
    );

    mockDatabaseHelper = MockDatabaseHelper();
    when(mockDatabaseHelper.database).thenAnswer((_) async => db);
    datasource = CalendarLocalDatasourceImpl(
      databaseHelper: mockDatabaseHelper,
    );

    await db.insert('notes', {
      'id': 'note_jan1',
      'title': 'Jan 1 Note',
      'content': 'Content',
      'color': 0xFFFF0000,
      'is_favorite': 0,
      'importance': 1,
      'created_at': '2026-01-01T10:00:00.000',
      'updated_at': '2026-01-01T10:00:00.000',
    });
    await db.insert('notes', {
      'id': 'note_jan1_pm',
      'title': 'Jan 1 PM Note',
      'content': 'Content',
      'color': 0xFF00FF00,
      'is_favorite': 0,
      'importance': 2,
      'created_at': '2026-01-01T18:00:00.000',
      'updated_at': '2026-01-01T18:00:00.000',
    });
    await db.insert('notes', {
      'id': 'note_jan5',
      'title': 'Jan 5 Note',
      'content': 'Content',
      'color': 0xFF0000FF,
      'is_favorite': 0,
      'importance': 3,
      'created_at': '2026-01-05T12:00:00.000',
      'updated_at': '2026-01-05T12:00:00.000',
    });
    await db.insert('notes', {
      'id': 'note_jan10',
      'title': 'Jan 10 Note',
      'content': 'Content',
      'color': 0xFFFFFF00,
      'is_favorite': 0,
      'importance': 1,
      'created_at': '2026-01-10T09:00:00.000',
      'updated_at': '2026-01-10T09:00:00.000',
    });
  });

  tearDown(() async {
    await db.close();
  });

  group('CalendarLocalDatasource', () {
    group('getNotesByDate', () {
      test('should return notes matching the given date', () async {
        final result = await datasource.getNotesByDate(DateTime(2026, 1, 1));

        expect(result.length, 2);
        expect(result[0].id, 'note_jan1_pm');
        expect(result[1].id, 'note_jan1');
      });

      test('should return empty list when no notes match the date', () async {
        final result = await datasource.getNotesByDate(DateTime(2026, 2, 15));

        expect(result, isEmpty);
      });

      test('should order results by created_at descending', () async {
        final result = await datasource.getNotesByDate(DateTime(2026, 1, 1));

        expect(result.length, 2);
        expect(result[0].createdAt.isAfter(result[1].createdAt), true);
      });
    });

    group('getNotesByDateRange', () {
      test('should return notes within the date range', () async {
        final result = await datasource.getNotesByDateRange(
          DateTime(2026, 1, 1),
          DateTime(2026, 1, 5, 23, 59, 59),
        );

        expect(result.length, 3);
      });

      test('should return all notes when range covers everything', () async {
        final result = await datasource.getNotesByDateRange(
          DateTime(2025, 12, 1),
          DateTime(2026, 12, 31),
        );

        expect(result.length, 4);
      });

      test('should return empty list when no notes in range', () async {
        final result = await datasource.getNotesByDateRange(
          DateTime(2026, 3, 1),
          DateTime(2026, 3, 31),
        );

        expect(result, isEmpty);
      });

      test('should return single note when range is exact', () async {
        final result = await datasource.getNotesByDateRange(
          DateTime(2026, 1, 10),
          DateTime(2026, 1, 10, 23, 59, 59),
        );

        expect(result.length, 1);
        expect(result[0].id, 'note_jan10');
      });

      test('should order results by created_at descending', () async {
        final result = await datasource.getNotesByDateRange(
          DateTime(2026, 1, 1),
          DateTime(2026, 1, 31),
        );

        for (int i = 0; i < result.length - 1; i++) {
          expect(
            result[i].createdAt.isAfter(result[i + 1].createdAt) ||
                result[i].createdAt == result[i + 1].createdAt,
            true,
          );
        }
      });
    });
  });
}
