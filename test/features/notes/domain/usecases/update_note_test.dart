import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/update_note.dart';
import '../../../../helpers/test_helpers.mocks.dart';
import '../../../../helpers/test_note_data.dart';

void main() {
  late MockNotesRepository mockRepository;
  late UpdateNote usecase;

  setUp(() {
    mockRepository = MockNotesRepository();
    usecase = UpdateNote(mockRepository);
  });

  group('UpdateNote', () {
    test('should return Right when repository succeeds', () async {
      when(
        mockRepository.updateNote(updatedNote),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase(updatedNote);

      expect(result, const Right(null));
      verify(mockRepository.updateNote(updatedNote)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left when repository fails', () async {
      when(
        mockRepository.updateNote(updatedNote),
      ).thenAnswer((_) async => Left(Exception('update error')));

      final result = await usecase(updatedNote);

      expect(result, isA<Left>());
      verify(mockRepository.updateNote(updatedNote)).called(1);
    });
  });
}
