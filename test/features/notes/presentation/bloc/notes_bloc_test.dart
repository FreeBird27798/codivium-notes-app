import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_state.dart';

void main() {
  group('NotesBloc', () {
    late NotesBloc notesBloc;

    setUp(() {
      notesBloc = NotesBloc();
    });

    tearDown(() {
      notesBloc.close();
    });

    test('initial state should be NotesInitial', () {
      expect(notesBloc.state, NotesInitial());
    });

    blocTest<NotesBloc, NotesState>(
      'emits [] when nothing is added',
      build: () => notesBloc,
      expect: () => [],
    );
  });
}


