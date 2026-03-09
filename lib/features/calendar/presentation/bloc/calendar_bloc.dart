import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codivium_notes_app/features/calendar/domain/usecases/get_notes_by_date.dart';
import 'package:codivium_notes_app/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:codivium_notes_app/features/calendar/presentation/bloc/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetNotesByDate getNotesByDate;

  CalendarBloc({required this.getNotesByDate}) : super(CalendarInitial()) {
    on<SelectDate>(_onSelectDate);
    on<SelectDateRange>(_onSelectDateRange);
  }

  Future<void> _onSelectDate(SelectDate event, Emitter<CalendarState> emit) async {}

  Future<void> _onSelectDateRange(SelectDateRange event, Emitter<CalendarState> emit) async {}
}

