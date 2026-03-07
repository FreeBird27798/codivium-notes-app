import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:codivium_notes_app/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:codivium_notes_app/features/calendar/presentation/bloc/calendar_state.dart';

void main() {
  group('CalendarBloc', () {
    late CalendarBloc calendarBloc;

    setUp(() {
      calendarBloc = CalendarBloc();
    });

    tearDown(() {
      calendarBloc.close();
    });

    test('initial state should be CalendarInitial', () {
      expect(calendarBloc.state, CalendarInitial());
    });

    blocTest<CalendarBloc, CalendarState>(
      'emits [] when nothing is added',
      build: () => calendarBloc,
      expect: () => [],
    );
  });
}


