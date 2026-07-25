import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/data/models/note_model.dart';
import 'package:codivium_notes_app/features/notes/data/repositories/notes_repository_impl.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late MockNotesLocalDatasource mockDatasource;
  late NotesRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockNotesLocalDatasource();
    repository = NotesRepositoryImpl(localDatasource: mockDatasource);
  });

  final now = DateTime(2026, 1, 1);
  final testNote = NoteModel(
    id: 'note_1',
    title: 'Test Note',
    content: 'Test Content',
    color: 0xFFFF0000,
    isFavorite: false,
    importance: 1,
    createdAt: now,
    updatedAt: now,
  );

  group('NotesRepositoryImpl', () {
    test(
      'should return list of notes when getAllNotes is successful',
      () async {
        when(mockDatasource.getAllNotes()).thenAnswer((_) async => [testNote]);

        final result = await repository.getAllNotes();

        expect(result, isA<Right>());
        result.fold((l) => fail('should not be Left'), (r) {
          expect(r.length, 1);
          expect(r.first.id, 'note_1');
        });
        verify(mockDatasource.getAllNotes()).called(1);
      },
    );

    test('should return Left when getAllNotes throws', () async {
      when(mockDatasource.getAllNotes()).thenThrow(Exception('db error'));

      final result = await repository.getAllNotes();

      expect(result, isA<Left>());
    });

    test('should return note when getNoteById is successful', () async {
      when(
        mockDatasource.getNoteById('note_1'),
      ).thenAnswer((_) async => testNote);

      final result = await repository.getNoteById('note_1');

      expect(result, isA<Right>());
      result.fold(
        (l) => fail('should not be Left'),
        (r) => expect(r.id, 'note_1'),
      );
      verify(mockDatasource.getNoteById('note_1')).called(1);
    });

    test('should return Left when getNoteById throws', () async {
      when(mockDatasource.getNoteById('bad')).thenThrow(Exception('not found'));

      final result = await repository.getNoteById('bad');

      expect(result, isA<Left>());
    });

    test('should create note successfully', () async {
      when(mockDatasource.createNote(any)).thenAnswer((_) async {});

      final result = await repository.createNote(testNote);

      expect(result, isA<Right>());
      verify(mockDatasource.createNote(any)).called(1);
    });

    test('should return Left when createNote throws', () async {
      when(mockDatasource.createNote(any)).thenThrow(Exception('insert error'));

      final result = await repository.createNote(testNote);

      expect(result, isA<Left>());
    });

    test('should update note successfully', () async {
      when(mockDatasource.updateNote(any)).thenAnswer((_) async {});

      final result = await repository.updateNote(testNote);

      expect(result, isA<Right>());
      verify(mockDatasource.updateNote(any)).called(1);
    });

    test('should return Left when updateNote throws', () async {
      when(mockDatasource.updateNote(any)).thenThrow(Exception('update error'));

      final result = await repository.updateNote(testNote);

      expect(result, isA<Left>());
    });

    test('should delete note successfully', () async {
      when(mockDatasource.deleteNote('note_1')).thenAnswer((_) async {});

      final result = await repository.deleteNote('note_1');

      expect(result, isA<Right>());
      verify(mockDatasource.deleteNote('note_1')).called(1);
    });

    test('should return Left when deleteNote throws', () async {
      when(
        mockDatasource.deleteNote('note_1'),
      ).thenThrow(Exception('delete error'));

      final result = await repository.deleteNote('note_1');

      expect(result, isA<Left>());
    });

    test('should toggle favorite successfully', () async {
      when(mockDatasource.toggleFavorite('note_1')).thenAnswer((_) async {});

      final result = await repository.toggleFavorite('note_1');

      expect(result, isA<Right>());
      verify(mockDatasource.toggleFavorite('note_1')).called(1);
    });

    test('should return Left when toggleFavorite throws', () async {
      when(
        mockDatasource.toggleFavorite('note_1'),
      ).thenThrow(Exception('fav error'));

      final result = await repository.toggleFavorite('note_1');

      expect(result, isA<Left>());
    });

    test(
      'should return sorted notes when sortByImportance is successful',
      () async {
        final note2 = NoteModel(
          id: 'note_2',
          title: 'Important',
          content: 'Content',
          color: 0xFF00FF00,
          isFavorite: false,
          importance: 5,
          createdAt: now,
          updatedAt: now,
        );
        when(
          mockDatasource.sortByImportance(),
        ).thenAnswer((_) async => [note2, testNote]);

        final result = await repository.sortByImportance();

        expect(result, isA<Right>());
        result.fold((l) => fail('should not be Left'), (r) {
          expect(r.length, 2);
          expect(r.first.importance, 5);
        });
      },
    );

    test('should return Left when sortByImportance throws', () async {
      when(
        mockDatasource.sortByImportance(),
      ).thenThrow(Exception('sort error'));

      final result = await repository.sortByImportance();

      expect(result, isA<Left>());
    });
  });
}
