import 'package:equatable/equatable.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<Note> notes;
  final DateTime selectedDate;
  const CalendarLoaded({required this.notes, required this.selectedDate});

  @override
  List<Object?> get props => [notes, selectedDate];
}

class CalendarError extends CalendarState {
  final String message;
  const CalendarError(this.message);

  @override
  List<Object?> get props => [message];
}
