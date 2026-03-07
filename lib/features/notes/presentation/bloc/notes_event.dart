import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NotesEvent {}

class LoadNoteById extends NotesEvent {
  final String id;
  const LoadNoteById(this.id);

  @override
  List<Object?> get props => [id];
}

class AddNote extends NotesEvent {}

class EditNote extends NotesEvent {
  final String id;
  const EditNote(this.id);

  @override
  List<Object?> get props => [id];
}

class RemoveNote extends NotesEvent {
  final String id;
  const RemoveNote(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleNoteFavorite extends NotesEvent {
  final String id;
  const ToggleNoteFavorite(this.id);

  @override
  List<Object?> get props => [id];
}

class SortByImportance extends NotesEvent {}

class ShareNoteEvent extends NotesEvent {
  final String id;
  const ShareNoteEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CopyNoteToClipboard extends NotesEvent {
  final String id;
  const CopyNoteToClipboard(this.id);

  @override
  List<Object?> get props => [id];
}

