import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codivium_notes_app/features/calendar/domain/usecases/get_notes_by_date.dart';
import 'package:codivium_notes_app/features/calendar/domain/usecases/get_notes_by_date_range.dart';
import 'package:codivium_notes_app/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:codivium_notes_app/features/calendar/presentation/bloc/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetNotesByDate getNotesByDate;
  final GetNotesByDateRange getNotesByDateRange;

  CalendarBloc({
    required this.getNotesByDate,
    required this.getNotesByDateRange,
  }) : super(CalendarInitial()) {
    on<SelectDate>(_onSelectDate);
    on<SelectDateRange>(_onSelectDateRange);
  }

  Future<void> _onSelectDate(
    SelectDate event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());
    final result = await getNotesByDate(event.date);
    result.fold(
      (error) => emit(CalendarError(error.toString())),
      (notes) => emit(CalendarLoaded(notes: notes, selectedDate: event.date)),
    );
  }

  Future<void> _onSelectDateRange(
    SelectDateRange event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());
    final result = await getNotesByDateRange(event.start, event.end);
    result.fold(
      (error) => emit(CalendarError(error.toString())),
      (notes) => emit(CalendarLoaded(notes: notes, selectedDate: event.start)),
    );
  }
}
