import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/get_note_by_id.dart';
import '../../../../helpers/test_helpers.mocks.dart';
import '../../../../helpers/test_note_data.dart';

void main() {
  late MockNotesRepository mockRepository;
  late GetNoteById usecase;

  setUp(() {
    mockRepository = MockNotesRepository();
    usecase = GetNoteById(mockRepository);
  });

  group('GetNoteById', () {
    test('should return Right with note when repository succeeds', () async {
      when(
        mockRepository.getNoteById('note_1'),
      ).thenAnswer((_) async => Right(testNote));

      final result = await usecase('note_1');

      expect(result, Right(testNote));
      verify(mockRepository.getNoteById('note_1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left when repository fails', () async {
      when(
        mockRepository.getNoteById('bad_id'),
      ).thenAnswer((_) async => Left(Exception('not found')));

      final result = await usecase('bad_id');

      expect(result, isA<Left>());
      verify(mockRepository.getNoteById('bad_id')).called(1);
    });
  });
}
