import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/get_note_by_id.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late MockNotesRepository mockRepository;
  late GetNoteById usecase;

  setUp(() {
    mockRepository = MockNotesRepository();
    usecase = GetNoteById(mockRepository);
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

  group('GetNoteById', () {
    test('should get note by id from the repository', () async {
      when(mockRepository.getNoteById('note_1')).thenAnswer((_) async => Right(testNote));

      final result = await usecase('note_1');

      expect(result, Right(testNote));
      verify(mockRepository.getNoteById('note_1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}

