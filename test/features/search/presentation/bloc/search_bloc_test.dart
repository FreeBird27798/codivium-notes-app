import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:codivium_notes_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:codivium_notes_app/features/search/presentation/bloc/search_state.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  group('SearchBloc', () {
    late SearchBloc searchBloc;
    late MockSearchNotes mockSearchNotes;

    setUp(() {
      mockSearchNotes = MockSearchNotes();
      searchBloc = SearchBloc(searchNotes: mockSearchNotes);
    });

    tearDown(() {
      searchBloc.close();
    });

    test('initial state should be SearchInitial', () {
      expect(searchBloc.state, SearchInitial());
    });

    blocTest<SearchBloc, SearchState>(
      'emits [] when nothing is added',
      build: () => SearchBloc(searchNotes: mockSearchNotes),
      expect: () => [],
    );
  });
}
