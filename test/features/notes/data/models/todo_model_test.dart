import 'package:flutter_test/flutter_test.dart';
import 'package:codivium_notes_app/features/notes/data/models/todo_model.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/todo.dart';

void main() {
  final testTodoModel = TodoModel(
    id: 'todo_1',
    noteId: 'note_1',
    text: 'Buy milk',
    isDone: false,
    order: 0,
  );

  group('TodoModel', () {
    test('should be a subclass of Todo entity', () {
      expect(testTodoModel, isA<Todo>());
    });

    test('should return a valid model from Map', () {
      final map = {
        'id': 'todo_1',
        'note_id': 'note_1',
        'todo_text': 'Buy milk',
        'is_done': 0,
        'sort_order': 0,
      };

      final result = TodoModel.fromMap(map);

      expect(result.id, 'todo_1');
      expect(result.noteId, 'note_1');
      expect(result.text, 'Buy milk');
      expect(result.isDone, false);
      expect(result.order, 0);
    });

    test('should return a Map containing proper data', () {
      final result = testTodoModel.toMap();

      expect(result['id'], 'todo_1');
      expect(result['note_id'], 'note_1');
      expect(result['todo_text'], 'Buy milk');
      expect(result['is_done'], 0);
      expect(result['sort_order'], 0);
    });
  });
}

