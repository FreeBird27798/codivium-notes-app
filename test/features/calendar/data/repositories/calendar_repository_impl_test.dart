import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:codivium_notes_app/features/notes/data/models/note_model.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late MockCalendarLocalDatasource mockDatasource;
  late CalendarRepositoryImpl repository;

  final date = DateTime(2026, 1, 1);
  final rangeStart = DateTime(2026, 1, 1);
  final rangeEnd = DateTime(2026, 1, 31);

  final noteModels = [
    NoteModel(
      id: 'note_1',
      title: 'Test',
      content: 'Content',
      color: 0xFFFF0000,
      isFavorite: false,
      importance: 1,
      createdAt: date,
      updatedAt: date,
    ),
  ];

  setUp(() {
    mockDatasource = MockCalendarLocalDatasource();
    repository = CalendarRepositoryImpl(localDatasource: mockDatasource);
  });

  group('CalendarRepositoryImpl', () {
    group('getNotesByDate', () {
      test('should return Right with notes when datasource succeeds', () async {
        when(
          mockDatasource.getNotesByDate(date),
        ).thenAnswer((_) async => noteModels);

        final result = await repository.getNotesByDate(date);

        expect(result, Right(noteModels));
        verify(mockDatasource.getNotesByDate(date)).called(1);
        verifyNoMoreInteractions(mockDatasource);
      });

      test('should return Left when datasource throws', () async {
        when(
          mockDatasource.getNotesByDate(date),
        ).thenThrow(Exception('db error'));

        final result = await repository.getNotesByDate(date);

        expect(result, isA<Left>());
        verify(mockDatasource.getNotesByDate(date)).called(1);
        verifyNoMoreInteractions(mockDatasource);
      });
    });

    group('getNotesByDateRange', () {
      test('should return Right with notes when datasource succeeds', () async {
        when(
          mockDatasource.getNotesByDateRange(rangeStart, rangeEnd),
        ).thenAnswer((_) async => noteModels);

        final result = await repository.getNotesByDateRange(
          rangeStart,
          rangeEnd,
        );

        expect(result, Right(noteModels));
        verify(
          mockDatasource.getNotesByDateRange(rangeStart, rangeEnd),
        ).called(1);
        verifyNoMoreInteractions(mockDatasource);
      });

      test('should return Left when datasource throws', () async {
        when(
          mockDatasource.getNotesByDateRange(rangeStart, rangeEnd),
        ).thenThrow(Exception('db error'));

        final result = await repository.getNotesByDateRange(
          rangeStart,
          rangeEnd,
        );

        expect(result, isA<Left>());
        verify(
          mockDatasource.getNotesByDateRange(rangeStart, rangeEnd),
        ).called(1);
        verifyNoMoreInteractions(mockDatasource);
      });
    });
  });
}
