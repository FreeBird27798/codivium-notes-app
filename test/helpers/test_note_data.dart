import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';

final testDate = DateTime(2026, 1, 1);

final testNote = Note(
  id: 'note_1',
  title: 'Test',
  content: 'Content',
  color: 0xFFFF0000,
  isFavorite: false,
  importance: 1,
  createdAt: testDate,
  updatedAt: testDate,
);

final updatedNote = Note(
  id: 'note_1',
  title: 'Updated',
  content: 'Updated Content',
  color: 0xFFFF0000,
  isFavorite: false,
  importance: 1,
  createdAt: testDate,
  updatedAt: testDate,
);

final importantNote = Note(
  id: 'note_2',
  title: 'Important',
  content: 'Content',
  color: 0xFF00FF00,
  isFavorite: false,
  importance: 5,
  createdAt: testDate,
  updatedAt: testDate,
);

final testNotes = [testNote];

final sortedNotes = [importantNote, testNote];
