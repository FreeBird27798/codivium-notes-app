import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/create_note.dart';
import '../../../../helpers/test_helpers.mocks.dart';
import '../../../../helpers/test_note_data.dart';

void main() {
  late MockNotesRepository mockRepository;
  late CreateNote usecase;

  setUp(() {
    mockRepository = MockNotesRepository();
    usecase = CreateNote(mockRepository);
  });

  group('CreateNote', () {
    test('should return Right when repository succeeds', () async {
      when(
        mockRepository.createNote(testNote),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase(testNote);

      expect(result, const Right(null));
      verify(mockRepository.createNote(testNote)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left when repository fails', () async {
      when(
        mockRepository.createNote(testNote),
      ).thenAnswer((_) async => Left(Exception('insert error')));

      final result = await usecase(testNote);

      expect(result, isA<Left>());
      verify(mockRepository.createNote(testNote)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
