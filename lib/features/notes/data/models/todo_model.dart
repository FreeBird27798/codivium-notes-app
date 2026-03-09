import 'package:codivium_notes_app/features/notes/domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.noteId,
    required super.text,
    required super.isDone,
    required super.order,
  });

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as String,
      noteId: map['note_id'] as String,
      text: map['todo_text'] as String,
      isDone: (map['is_done'] as int) == 1,
      order: map['sort_order'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note_id': noteId,
      'todo_text': text,
      'is_done': isDone ? 1 : 0,
      'sort_order': order,
    };
  }
}
