import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/update_note.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late MockNotesRepository mockRepository;
  late UpdateNote usecase;

  setUp(() {
    mockRepository = MockNotesRepository();
    usecase = UpdateNote(mockRepository);
  });

  final now = DateTime(2026, 1, 1);
  final testNote = Note(
    id: 'note_1',
    title: 'Updated',
    content: 'Updated Content',
    color: 0xFFFF0000,
    isFavorite: false,
    importance: 1,
    createdAt: now,
    updatedAt: now,
  );

  group('UpdateNote', () {
    test('should update note via the repository', () async {
      when(mockRepository.updateNote(testNote)).thenAnswer((_) async => const Right(null));

      final result = await usecase(testNote);

      expect(result, const Right(null));
      verify(mockRepository.updateNote(testNote)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}

