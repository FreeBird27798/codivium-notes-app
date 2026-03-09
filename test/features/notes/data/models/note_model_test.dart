import 'package:flutter_test/flutter_test.dart';
import 'package:codivium_notes_app/features/notes/data/models/note_model.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';

void main() {
  final now = DateTime(2026, 1, 1);
  final testNoteModel = NoteModel(
    id: 'note_1',
    title: 'Test Note',
    content: 'Test Content',
    color: 0xFFFF0000,
    isFavorite: true,
    importance: 3,
    createdAt: now,
    updatedAt: now,
  );

  group('NoteModel', () {
    test('should be a subclass of Note entity', () {
      expect(testNoteModel, isA<Note>());
    });

    test('should return a valid model from Map', () {
      final map = {
        'id': 'note_1',
        'title': 'Test Note',
        'content': 'Test Content',
        'color': 0xFFFF0000,
        'is_favorite': 1,
        'importance': 3,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      final result = NoteModel.fromMap(map);

      expect(result.id, 'note_1');
      expect(result.title, 'Test Note');
      expect(result.content, 'Test Content');
      expect(result.color, 0xFFFF0000);
      expect(result.isFavorite, true);
      expect(result.importance, 3);
      expect(result.createdAt, now);
      expect(result.updatedAt, now);
    });

    test('should return a Map containing proper data', () {
      final result = testNoteModel.toMap();

      expect(result['id'], 'note_1');
      expect(result['title'], 'Test Note');
      expect(result['content'], 'Test Content');
      expect(result['color'], 0xFFFF0000);
      expect(result['is_favorite'], 1);
      expect(result['importance'], 3);
      expect(result['created_at'], now.toIso8601String());
      expect(result['updated_at'], now.toIso8601String());
    });
  });
}

