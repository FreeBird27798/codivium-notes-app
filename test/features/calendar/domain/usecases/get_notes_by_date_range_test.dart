import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/calendar/domain/usecases/get_notes_by_date_range.dart';
import '../../../../helpers/test_helpers.mocks.dart';
import '../../../../helpers/test_note_data.dart';

void main() {
  late MockCalendarRepository mockRepository;
  late GetNotesByDateRange usecase;

  final rangeStart = DateTime(2026, 1, 1);
  final rangeEnd = DateTime(2026, 1, 31);

  setUp(() {
    mockRepository = MockCalendarRepository();
    usecase = GetNotesByDateRange(mockRepository);
  });

  group('GetNotesByDateRange', () {
    test('should return Right with notes when repository succeeds', () async {
      when(
        mockRepository.getNotesByDateRange(rangeStart, rangeEnd),
      ).thenAnswer((_) async => Right(testNotes));

      final result = await usecase(rangeStart, rangeEnd);

      expect(result, Right(testNotes));
      verify(
        mockRepository.getNotesByDateRange(rangeStart, rangeEnd),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left when repository fails', () async {
      when(
        mockRepository.getNotesByDateRange(rangeStart, rangeEnd),
      ).thenAnswer((_) async => Left(Exception('db error')));

      final result = await usecase(rangeStart, rangeEnd);

      expect(result, isA<Left>());
      verify(
        mockRepository.getNotesByDateRange(rangeStart, rangeEnd),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
