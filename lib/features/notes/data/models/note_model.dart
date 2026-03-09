import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    required super.id,
    required super.title,
    required super.content,
    required super.color,
    required super.isFavorite,
    required super.importance,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      color: map['color'] as int,
      isFavorite: (map['is_favorite'] as int) == 1,
      importance: map['importance'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'is_favorite': isFavorite ? 1 : 0,
      'importance': importance,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
