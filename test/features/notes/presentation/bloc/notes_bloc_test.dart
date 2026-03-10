import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_event.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_state.dart';
import '../../../../helpers/test_helpers.mocks.dart';
import '../../../../helpers/test_note_data.dart';

void main() {
  late MockGetAllNotes mockGetAllNotes;
  late MockGetNoteById mockGetNoteById;
  late MockCreateNote mockCreateNote;
  late MockUpdateNote mockUpdateNote;
  late MockDeleteNote mockDeleteNote;
  late MockToggleFavorite mockToggleFavorite;
  late MockSortNotesByImportance mockSortNotesByImportance;
  late MockShareNote mockShareNote;
  late MockClipboardHelper mockClipboardHelper;

  setUp(() {
    mockGetAllNotes = MockGetAllNotes();
    mockGetNoteById = MockGetNoteById();
    mockCreateNote = MockCreateNote();
    mockUpdateNote = MockUpdateNote();
    mockDeleteNote = MockDeleteNote();
    mockToggleFavorite = MockToggleFavorite();
    mockSortNotesByImportance = MockSortNotesByImportance();
    mockShareNote = MockShareNote();
    mockClipboardHelper = MockClipboardHelper();
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
    clipboardHelper: mockClipboardHelper,
  );

  group('NotesBloc', () {
    test('initial state should be NotesInitial', () {
      final bloc = buildBloc();
      expect(bloc.state, NotesInitial());
      bloc.close();
    });

    group('LoadNotes', () {
      blocTest<NotesBloc, NotesState>(
        'emits [NotesLoading, NotesLoaded] when succeeds',
        build: () {
          when(mockGetAllNotes()).thenAnswer((_) async => Right(testNotes));
          return buildBloc();
        },
        act: (bloc) => bloc.add(LoadNotes()),
        expect: () => [NotesLoading(), NotesLoaded(testNotes)],
      );

      blocTest<NotesBloc, NotesState>(
        'emits [NotesLoading, NotesError] when fails',
        build: () {
          when(
            mockGetAllNotes(),
          ).thenAnswer((_) async => Left(Exception('db error')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(LoadNotes()),
        expect: () => [NotesLoading(), isA<NotesError>()],
      );
    });

    group('LoadNoteById', () {
      blocTest<NotesBloc, NotesState>(
        'emits [NotesLoading, NoteDetailLoaded] when succeeds',
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
        'emits [NotesLoading, NotesError] when fails',
        build: () {
          when(
            mockGetNoteById('bad'),
          ).thenAnswer((_) async => Left(Exception('not found')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const LoadNoteById('bad')),
        expect: () => [NotesLoading(), isA<NotesError>()],
      );
    });

    group('AddNote', () {
      blocTest<NotesBloc, NotesState>(
        'emits [NotesLoading, NotesLoaded] when succeeds',
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
        'emits [NotesLoading, NotesError] when fails',
        build: () {
          when(
            mockCreateNote(testNote),
          ).thenAnswer((_) async => Left(Exception('insert error')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(AddNote(testNote)),
        expect: () => [NotesLoading(), isA<NotesError>()],
      );
    });

    group('EditNote', () {
      blocTest<NotesBloc, NotesState>(
        'emits [NotesLoading, NotesLoaded] when succeeds',
        build: () {
          when(
            mockUpdateNote(updatedNote),
          ).thenAnswer((_) async => const Right(null));
          when(mockGetAllNotes()).thenAnswer((_) async => Right(testNotes));
          return buildBloc();
        },
        act: (bloc) => bloc.add(EditNote(updatedNote)),
        expect: () => [NotesLoading(), NotesLoaded(testNotes)],
      );

      blocTest<NotesBloc, NotesState>(
        'emits [NotesLoading, NotesError] when fails',
        build: () {
          when(
            mockUpdateNote(updatedNote),
          ).thenAnswer((_) async => Left(Exception('update error')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(EditNote(updatedNote)),
        expect: () => [NotesLoading(), isA<NotesError>()],
      );
    });

    group('RemoveNote', () {
      blocTest<NotesBloc, NotesState>(
        'emits [NotesLoading, NotesLoaded] when succeeds',
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
        'emits [NotesLoading, NotesError] when fails',
        build: () {
          when(
            mockDeleteNote('note_1'),
          ).thenAnswer((_) async => Left(Exception('delete error')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const RemoveNote('note_1')),
        expect: () => [NotesLoading(), isA<NotesError>()],
      );
    });

    group('ToggleNoteFavorite', () {
      blocTest<NotesBloc, NotesState>(
        'emits [NotesLoading, NotesLoaded] when succeeds',
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

      blocTest<NotesBloc, NotesState>(
        'emits [NotesLoading, NotesError] when fails',
        build: () {
          when(
            mockToggleFavorite('note_1'),
          ).thenAnswer((_) async => Left(Exception('fav error')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ToggleNoteFavorite('note_1')),
        expect: () => [NotesLoading(), isA<NotesError>()],
      );
    });

    group('SortByImportance', () {
      blocTest<NotesBloc, NotesState>(
        'emits [NotesLoading, NotesLoaded] when succeeds',
        build: () {
          when(
            mockSortNotesByImportance(),
          ).thenAnswer((_) async => Right(sortedNotes));
          return buildBloc();
        },
        act: (bloc) => bloc.add(SortByImportance()),
        expect: () => [NotesLoading(), NotesLoaded(sortedNotes)],
      );

      blocTest<NotesBloc, NotesState>(
        'emits [NotesLoading, NotesError] when fails',
        build: () {
          when(
            mockSortNotesByImportance(),
          ).thenAnswer((_) async => Left(Exception('sort error')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(SortByImportance()),
        expect: () => [NotesLoading(), isA<NotesError>()],
      );
    });

    group('ShareNoteEvent', () {
      blocTest<NotesBloc, NotesState>(
        'emits [NoteShared] when succeeds',
        build: () {
          when(
            mockGetNoteById('note_1'),
          ).thenAnswer((_) async => Right(testNote));
          when(
            mockShareNote(title: 'Test', content: 'Content'),
          ).thenAnswer((_) async {});
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ShareNoteEvent('note_1')),
        expect: () => [isA<NoteShared>()],
      );

      blocTest<NotesBloc, NotesState>(
        'emits [NotesError] when note not found',
        build: () {
          when(
            mockGetNoteById('bad'),
          ).thenAnswer((_) async => Left(Exception('not found')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ShareNoteEvent('bad')),
        expect: () => [isA<NotesError>()],
      );

      blocTest<NotesBloc, NotesState>(
        'emits [NotesError] when share throws',
        build: () {
          when(
            mockGetNoteById('note_1'),
          ).thenAnswer((_) async => Right(testNote));
          when(
            mockShareNote(title: 'Test', content: 'Content'),
          ).thenThrow(Exception('share failed'));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ShareNoteEvent('note_1')),
        expect: () => [isA<NotesError>()],
      );
    });

    group('CopyNoteToClipboard', () {
      blocTest<NotesBloc, NotesState>(
        'emits [NoteCopied] when succeeds',
        build: () {
          when(
            mockGetNoteById('note_1'),
          ).thenAnswer((_) async => Right(testNote));
          when(
            mockClipboardHelper.copy('Test\n\nContent'),
          ).thenAnswer((_) async => true);
          return buildBloc();
        },
        act: (bloc) => bloc.add(const CopyNoteToClipboard('note_1')),
        expect: () => [isA<NoteCopied>()],
      );

      blocTest<NotesBloc, NotesState>(
        'emits [NotesError] when note not found',
        build: () {
          when(
            mockGetNoteById('bad'),
          ).thenAnswer((_) async => Left(Exception('not found')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const CopyNoteToClipboard('bad')),
        expect: () => [isA<NotesError>()],
      );

      blocTest<NotesBloc, NotesState>(
        'emits [NotesError] when clipboard copy fails',
        build: () {
          when(
            mockGetNoteById('note_1'),
          ).thenAnswer((_) async => Right(testNote));
          when(
            mockClipboardHelper.copy('Test\n\nContent'),
          ).thenAnswer((_) async => false);
          return buildBloc();
        },
        act: (bloc) => bloc.add(const CopyNoteToClipboard('note_1')),
        expect: () => [isA<NotesError>()],
      );
    });
  });
}
