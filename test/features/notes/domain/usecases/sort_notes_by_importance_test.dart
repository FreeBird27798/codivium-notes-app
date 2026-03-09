import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/sort_notes_by_importance.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late MockNotesRepository mockRepository;
  late SortNotesByImportance usecase;

  setUp(() {
    mockRepository = MockNotesRepository();
    usecase = SortNotesByImportance(mockRepository);
  });

  final now = DateTime(2026, 1, 1);
  final sortedNotes = [
    Note(
      id: 'note_2',
      title: 'Important',
      content: 'Content',
      color: 0xFF00FF00,
      isFavorite: false,
      importance: 5,
      createdAt: now,
      updatedAt: now,
    ),
    Note(
      id: 'note_1',
      title: 'Normal',
      content: 'Content',
      color: 0xFFFF0000,
      isFavorite: false,
      importance: 1,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  group('SortNotesByImportance', () {
    test('should return notes sorted by importance', () async {
      when(
        mockRepository.sortByImportance(),
      ).thenAnswer((_) async => Right(sortedNotes));

      final result = await usecase();

      expect(result, Right(sortedNotes));
      verify(mockRepository.sortByImportance()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
