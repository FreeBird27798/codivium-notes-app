import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_state.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  group('NotesBloc', () {
    late NotesBloc notesBloc;
    late MockGetAllNotes mockGetAllNotes;
    late MockGetNoteById mockGetNoteById;
    late MockCreateNote mockCreateNote;
    late MockUpdateNote mockUpdateNote;
    late MockDeleteNote mockDeleteNote;
    late MockToggleFavorite mockToggleFavorite;
    late MockSortNotesByImportance mockSortNotesByImportance;
    late MockShareNote mockShareNote;

    setUp(() {
      mockGetAllNotes = MockGetAllNotes();
      mockGetNoteById = MockGetNoteById();
      mockCreateNote = MockCreateNote();
      mockUpdateNote = MockUpdateNote();
      mockDeleteNote = MockDeleteNote();
      mockToggleFavorite = MockToggleFavorite();
      mockSortNotesByImportance = MockSortNotesByImportance();
      mockShareNote = MockShareNote();
      notesBloc = NotesBloc(
        getAllNotes: mockGetAllNotes,
        getNoteById: mockGetNoteById,
        createNote: mockCreateNote,
        updateNote: mockUpdateNote,
        deleteNote: mockDeleteNote,
        toggleFavorite: mockToggleFavorite,
        sortNotesByImportance: mockSortNotesByImportance,
        shareNote: mockShareNote,
      );
    });

    tearDown(() {
      notesBloc.close();
    });

    test('initial state should be NotesInitial', () {
      expect(notesBloc.state, NotesInitial());
    });

    blocTest<NotesBloc, NotesState>(
      'emits [] when nothing is added',
      build: () => NotesBloc(
        getAllNotes: mockGetAllNotes,
        getNoteById: mockGetNoteById,
        createNote: mockCreateNote,
        updateNote: mockUpdateNote,
        deleteNote: mockDeleteNote,
        toggleFavorite: mockToggleFavorite,
        sortNotesByImportance: mockSortNotesByImportance,
        shareNote: mockShareNote,
      ),
      expect: () => [],
    );
  });
}


