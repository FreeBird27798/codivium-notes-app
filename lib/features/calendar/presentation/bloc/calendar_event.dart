import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class SelectDate extends CalendarEvent {
  final DateTime date;
  const SelectDate(this.date);

  @override
  List<Object?> get props => [date];
}

class SelectDateRange extends CalendarEvent {
  final DateTime start;
  final DateTime end;
  const SelectDateRange(this.start, this.end);

  @override
  List<Object?> get props => [start, end];
}
