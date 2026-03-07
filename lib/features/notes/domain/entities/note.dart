import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  final String title;
  final String content;
  final int color;
  final bool isFavorite;
  final int importance;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.isFavorite,
    required this.importance,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        color,
        isFavorite,
        importance,
        createdAt,
        updatedAt,
      ];
}

