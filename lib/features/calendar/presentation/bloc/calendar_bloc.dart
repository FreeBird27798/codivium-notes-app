import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codivium_notes_app/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:codivium_notes_app/features/calendar/presentation/bloc/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial()) {
    on<SelectDate>(_onSelectDate);
    on<SelectDateRange>(_onSelectDateRange);
  }

  Future<void> _onSelectDate(SelectDate event, Emitter<CalendarState> emit) async {}

  Future<void> _onSelectDateRange(SelectDateRange event, Emitter<CalendarState> emit) async {}
}

