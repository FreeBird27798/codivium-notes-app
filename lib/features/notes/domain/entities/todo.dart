import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String noteId;
  final String text;
  final bool isDone;
  final int order;

  const Todo({
    required this.id,
    required this.noteId,
    required this.text,
    required this.isDone,
    required this.order,
  });

  @override
  List<Object?> get props => [id, noteId, text, isDone, order];
}
