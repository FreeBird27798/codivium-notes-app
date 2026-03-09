import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/get_all_notes.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late MockNotesRepository mockRepository;
  late GetAllNotes usecase;

  setUp(() {
    mockRepository = MockNotesRepository();
    usecase = GetAllNotes(mockRepository);
  });

  final now = DateTime(2026, 1, 1);
  final testNotes = [
    Note(
      id: 'note_1',
      title: 'Test',
      content: 'Content',
      color: 0xFFFF0000,
      isFavorite: false,
      importance: 1,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  group('GetAllNotes', () {
    test('should get all notes from the repository', () async {
      when(mockRepository.getAllNotes()).thenAnswer((_) async => Right(testNotes));

      final result = await usecase();

      expect(result, Right(testNotes));
      verify(mockRepository.getAllNotes()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}

