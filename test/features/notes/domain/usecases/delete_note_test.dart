import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/delete_note.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late MockNotesRepository mockRepository;
  late DeleteNote usecase;

  setUp(() {
    mockRepository = MockNotesRepository();
    usecase = DeleteNote(mockRepository);
  });

  group('DeleteNote', () {
    test('should delete note via the repository', () async {
      when(mockRepository.deleteNote('note_1')).thenAnswer((_) async => const Right(null));

      final result = await usecase('note_1');

      expect(result, const Right(null));
      verify(mockRepository.deleteNote('note_1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}

