import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/sort_notes_by_importance.dart';
import '../../../../helpers/test_helpers.mocks.dart';
import '../../../../helpers/test_note_data.dart';

void main() {
  late MockNotesRepository mockRepository;
  late SortNotesByImportance usecase;

  setUp(() {
    mockRepository = MockNotesRepository();
    usecase = SortNotesByImportance(mockRepository);
  });

  group('SortNotesByImportance', () {
    test(
      'should return Right with sorted notes when repository succeeds',
      () async {
        when(
          mockRepository.sortByImportance(),
        ).thenAnswer((_) async => Right(sortedNotes));

        final result = await usecase();

        expect(result, Right(sortedNotes));
        verify(mockRepository.sortByImportance()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return Left when repository fails', () async {
      when(
        mockRepository.sortByImportance(),
      ).thenAnswer((_) async => Left(Exception('sort error')));

      final result = await usecase();

      expect(result, isA<Left>());
      verify(mockRepository.sortByImportance()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
