import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/get_all_notes.dart';
import '../../../../helpers/test_helpers.mocks.dart';
import '../../../../helpers/test_note_data.dart';

void main() {
  late MockNotesRepository mockRepository;
  late GetAllNotes usecase;

  setUp(() {
    mockRepository = MockNotesRepository();
    usecase = GetAllNotes(mockRepository);
  });

  group('GetAllNotes', () {
    test('should return Right with notes when repository succeeds', () async {
      when(
        mockRepository.getAllNotes(),
      ).thenAnswer((_) async => Right(testNotes));

      final result = await usecase();

      expect(result, Right(testNotes));
      verify(mockRepository.getAllNotes()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left when repository fails', () async {
      when(
        mockRepository.getAllNotes(),
      ).thenAnswer((_) async => Left(Exception('db error')));

      final result = await usecase();

      expect(result, isA<Left>());
      verify(mockRepository.getAllNotes()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
