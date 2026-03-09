import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/create_note.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late MockNotesRepository mockRepository;
  late CreateNote usecase;

  setUp(() {
    mockRepository = MockNotesRepository();
    usecase = CreateNote(mockRepository);
  });

  final now = DateTime(2026, 1, 1);
  final testNote = Note(
    id: 'note_1',
    title: 'Test',
    content: 'Content',
    color: 0xFFFF0000,
    isFavorite: false,
    importance: 1,
    createdAt: now,
    updatedAt: now,
  );

  group('CreateNote', () {
    test('should create note via the repository', () async {
      when(
        mockRepository.createNote(testNote),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase(testNote);

      expect(result, const Right(null));
      verify(mockRepository.createNote(testNote)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
