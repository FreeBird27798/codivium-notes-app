import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_event.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_state.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late MockGetAllNotes mockGetAllNotes;
  late MockGetNoteById mockGetNoteById;
  late MockCreateNote mockCreateNote;
  late MockUpdateNote mockUpdateNote;
  late MockDeleteNote mockDeleteNote;
  late MockToggleFavorite mockToggleFavorite;
  late MockSortNotesByImportance mockSortNotesByImportance;
  late MockShareNote mockShareNote;

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
  final testNote = testNotes.first;

  setUp(() {
    mockGetAllNotes = MockGetAllNotes();
    mockGetNoteById = MockGetNoteById();
    mockCreateNote = MockCreateNote();
    mockUpdateNote = MockUpdateNote();
    mockDeleteNote = MockDeleteNote();
    mockToggleFavorite = MockToggleFavorite();
    mockSortNotesByImportance = MockSortNotesByImportance();
    mockShareNote = MockShareNote();
  });

  NotesBloc buildBloc() => NotesBloc(
    getAllNotes: mockGetAllNotes,
    getNoteById: mockGetNoteById,
    createNote: mockCreateNote,
    updateNote: mockUpdateNote,
    deleteNote: mockDeleteNote,
    toggleFavorite: mockToggleFavorite,
    sortNotesByImportance: mockSortNotesByImportance,
    shareNote: mockShareNote,
  );

  group('NotesBloc', () {
    test('initial state should be NotesInitial', () {
      final bloc = buildBloc();
      expect(bloc.state, NotesInitial());
      bloc.close();
    });

    blocTest<NotesBloc, NotesState>(
      'emits [NotesLoading, NotesLoaded] when LoadNotes succeeds',
      build: () {
        when(mockGetAllNotes()).thenAnswer((_) async => Right(testNotes));
        return buildBloc();
      },
      act: (bloc) => bloc.add(LoadNotes()),
      expect: () => [NotesLoading(), NotesLoaded(testNotes)],
    );

    blocTest<NotesBloc, NotesState>(
      'emits [NotesLoading, NotesError] when LoadNotes fails',
      build: () {
        when(
          mockGetAllNotes(),
        ).thenAnswer((_) async => Left(Exception('db error')));
        return buildBloc();
      },
      act: (bloc) => bloc.add(LoadNotes()),
      expect: () => [NotesLoading(), isA<NotesError>()],
    );

    blocTest<NotesBloc, NotesState>(
      'emits [NotesLoading, NoteDetailLoaded] when LoadNoteById succeeds',
      build: () {
        when(
          mockGetNoteById('note_1'),
        ).thenAnswer((_) async => Right(testNote));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadNoteById('note_1')),
      expect: () => [NotesLoading(), NoteDetailLoaded(testNote)],
    );

    blocTest<NotesBloc, NotesState>(
      'emits [NotesLoading, NotesError] when LoadNoteById fails',
      build: () {
        when(
          mockGetNoteById('bad'),
        ).thenAnswer((_) async => Left(Exception('not found')));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadNoteById('bad')),
      expect: () => [NotesLoading(), isA<NotesError>()],
    );

    blocTest<NotesBloc, NotesState>(
      'emits [NotesLoading, NotesLoaded] when AddNote succeeds',
      build: () {
        when(
          mockCreateNote(testNote),
        ).thenAnswer((_) async => const Right(null));
        when(mockGetAllNotes()).thenAnswer((_) async => Right(testNotes));
        return buildBloc();
      },
      act: (bloc) => bloc.add(AddNote(testNote)),
      expect: () => [NotesLoading(), NotesLoaded(testNotes)],
    );

    blocTest<NotesBloc, NotesState>(
      'emits [NotesLoading, NotesError] when AddNote fails',
      build: () {
        when(
          mockCreateNote(testNote),
        ).thenAnswer((_) async => Left(Exception('insert error')));
        return buildBloc();
      },
      act: (bloc) => bloc.add(AddNote(testNote)),
      expect: () => [NotesLoading(), isA<NotesError>()],
    );

    blocTest<NotesBloc, NotesState>(
      'emits [NotesLoading, NotesLoaded] when RemoveNote succeeds',
      build: () {
        when(
          mockDeleteNote('note_1'),
        ).thenAnswer((_) async => const Right(null));
        when(mockGetAllNotes()).thenAnswer((_) async => const Right([]));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const RemoveNote('note_1')),
      expect: () => [NotesLoading(), const NotesLoaded([])],
    );

    blocTest<NotesBloc, NotesState>(
      'emits [NotesLoading, NotesLoaded] when SortByImportance succeeds',
      build: () {
        when(
          mockSortNotesByImportance(),
        ).thenAnswer((_) async => Right(testNotes));
        return buildBloc();
      },
      act: (bloc) => bloc.add(SortByImportance()),
      expect: () => [NotesLoading(), NotesLoaded(testNotes)],
    );

    blocTest<NotesBloc, NotesState>(
      'emits [NotesLoading, NotesLoaded] when ToggleNoteFavorite succeeds',
      build: () {
        when(
          mockToggleFavorite('note_1'),
        ).thenAnswer((_) async => const Right(null));
        when(mockGetAllNotes()).thenAnswer((_) async => Right(testNotes));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ToggleNoteFavorite('note_1')),
      expect: () => [NotesLoading(), NotesLoaded(testNotes)],
    );
  });
}
