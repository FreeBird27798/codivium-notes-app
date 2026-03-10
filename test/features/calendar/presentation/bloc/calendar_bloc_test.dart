import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:codivium_notes_app/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:codivium_notes_app/features/calendar/presentation/bloc/calendar_state.dart';
import '../../../../helpers/test_helpers.mocks.dart';
import '../../../../helpers/test_note_data.dart';

void main() {
  late MockGetNotesByDate mockGetNotesByDate;
  late MockGetNotesByDateRange mockGetNotesByDateRange;

  final selectedDate = DateTime(2026, 1, 1);
  final rangeStart = DateTime(2026, 1, 1);
  final rangeEnd = DateTime(2026, 1, 31);

  setUp(() {
    mockGetNotesByDate = MockGetNotesByDate();
    mockGetNotesByDateRange = MockGetNotesByDateRange();
  });

  CalendarBloc buildBloc() => CalendarBloc(
    getNotesByDate: mockGetNotesByDate,
    getNotesByDateRange: mockGetNotesByDateRange,
  );

  group('CalendarBloc', () {
    test('initial state should be CalendarInitial', () {
      final bloc = buildBloc();
      expect(bloc.state, CalendarInitial());
      bloc.close();
    });

    group('SelectDate', () {
      blocTest<CalendarBloc, CalendarState>(
        'emits [CalendarLoading, CalendarLoaded] when succeeds',
        build: () {
          when(
            mockGetNotesByDate(selectedDate),
          ).thenAnswer((_) async => Right(testNotes));
          return buildBloc();
        },
        act: (bloc) => bloc.add(SelectDate(selectedDate)),
        expect: () => [
          CalendarLoading(),
          CalendarLoaded(notes: testNotes, selectedDate: selectedDate),
        ],
        verify: (_) {
          verify(mockGetNotesByDate(selectedDate)).called(1);
          verifyNoMoreInteractions(mockGetNotesByDate);
        },
      );

      blocTest<CalendarBloc, CalendarState>(
        'emits [CalendarLoading, CalendarError] when fails',
        build: () {
          when(
            mockGetNotesByDate(selectedDate),
          ).thenAnswer((_) async => Left(Exception('db error')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(SelectDate(selectedDate)),
        expect: () => [CalendarLoading(), isA<CalendarError>()],
        verify: (_) {
          verify(mockGetNotesByDate(selectedDate)).called(1);
        },
      );

      blocTest<CalendarBloc, CalendarState>(
        'emits [CalendarLoading, CalendarLoaded] with empty list when no notes on date',
        build: () {
          when(
            mockGetNotesByDate(selectedDate),
          ).thenAnswer((_) async => const Right([]));
          return buildBloc();
        },
        act: (bloc) => bloc.add(SelectDate(selectedDate)),
        expect: () => [
          CalendarLoading(),
          CalendarLoaded(notes: const [], selectedDate: selectedDate),
        ],
      );
    });

    group('SelectDateRange', () {
      blocTest<CalendarBloc, CalendarState>(
        'emits [CalendarLoading, CalendarLoaded] when succeeds',
        build: () {
          when(
            mockGetNotesByDateRange(rangeStart, rangeEnd),
          ).thenAnswer((_) async => Right(testNotes));
          return buildBloc();
        },
        act: (bloc) => bloc.add(SelectDateRange(rangeStart, rangeEnd)),
        expect: () => [
          CalendarLoading(),
          CalendarLoaded(notes: testNotes, selectedDate: rangeStart),
        ],
        verify: (_) {
          verify(mockGetNotesByDateRange(rangeStart, rangeEnd)).called(1);
          verifyNoMoreInteractions(mockGetNotesByDateRange);
        },
      );

      blocTest<CalendarBloc, CalendarState>(
        'emits [CalendarLoading, CalendarError] when fails',
        build: () {
          when(
            mockGetNotesByDateRange(rangeStart, rangeEnd),
          ).thenAnswer((_) async => Left(Exception('db error')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(SelectDateRange(rangeStart, rangeEnd)),
        expect: () => [CalendarLoading(), isA<CalendarError>()],
        verify: (_) {
          verify(mockGetNotesByDateRange(rangeStart, rangeEnd)).called(1);
        },
      );

      blocTest<CalendarBloc, CalendarState>(
        'emits [CalendarLoading, CalendarLoaded] with empty list when no notes in range',
        build: () {
          when(
            mockGetNotesByDateRange(rangeStart, rangeEnd),
          ).thenAnswer((_) async => const Right([]));
          return buildBloc();
        },
        act: (bloc) => bloc.add(SelectDateRange(rangeStart, rangeEnd)),
        expect: () => [
          CalendarLoading(),
          CalendarLoaded(notes: const [], selectedDate: rangeStart),
        ],
      );
    });
  });
}
