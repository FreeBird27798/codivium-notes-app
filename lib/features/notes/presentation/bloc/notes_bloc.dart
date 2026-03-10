import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codivium_notes_app/core/utils/clipboard_helper.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/get_all_notes.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/get_note_by_id.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/create_note.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/update_note.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/delete_note.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/toggle_favorite.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/sort_notes_by_importance.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/share_note.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_event.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetAllNotes getAllNotes;
  final GetNoteById getNoteById;
  final CreateNote createNote;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;
  final ToggleFavorite toggleFavorite;
  final SortNotesByImportance sortNotesByImportance;
  final ShareNote shareNote;
  final ClipboardHelper clipboardHelper;

  NotesBloc({
    required this.getAllNotes,
    required this.getNoteById,
    required this.createNote,
    required this.updateNote,
    required this.deleteNote,
    required this.toggleFavorite,
    required this.sortNotesByImportance,
    required this.shareNote,
    required this.clipboardHelper,
  }) : super(NotesInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<LoadNoteById>(_onLoadNoteById);
    on<AddNote>(_onAddNote);
    on<EditNote>(_onEditNote);
    on<RemoveNote>(_onRemoveNote);
    on<ToggleNoteFavorite>(_onToggleFavorite);
    on<SortByImportance>(_onSortByImportance);
    on<ShareNoteEvent>(_onShareNote);
    on<CopyNoteToClipboard>(_onCopyToClipboard);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    final result = await getAllNotes();
    result.fold(
      (error) => emit(NotesError(error.toString())),
      (notes) => emit(NotesLoaded(notes)),
    );
  }

  Future<void> _onLoadNoteById(
    LoadNoteById event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    final result = await getNoteById(event.id);
    result.fold(
      (error) => emit(NotesError(error.toString())),
      (note) => emit(NoteDetailLoaded(note)),
    );
  }

  Future<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    final result = await createNote(event.note);
    if (result.isLeft()) {
      result.fold((error) => emit(NotesError(error.toString())), (_) {});
      return;
    }
    final refreshed = await getAllNotes();
    refreshed.fold(
      (error) => emit(NotesError(error.toString())),
      (notes) => emit(NotesLoaded(notes)),
    );
  }

  Future<void> _onEditNote(EditNote event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    final result = await updateNote(event.note);
    if (result.isLeft()) {
      result.fold((error) => emit(NotesError(error.toString())), (_) {});
      return;
    }
    final refreshed = await getAllNotes();
    refreshed.fold(
      (error) => emit(NotesError(error.toString())),
      (notes) => emit(NotesLoaded(notes)),
    );
  }

  Future<void> _onRemoveNote(RemoveNote event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    final result = await deleteNote(event.id);
    if (result.isLeft()) {
      result.fold((error) => emit(NotesError(error.toString())), (_) {});
      return;
    }
    final refreshed = await getAllNotes();
    refreshed.fold(
      (error) => emit(NotesError(error.toString())),
      (notes) => emit(NotesLoaded(notes)),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleNoteFavorite event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    final result = await toggleFavorite(event.id);
    if (result.isLeft()) {
      result.fold((error) => emit(NotesError(error.toString())), (_) {});
      return;
    }
    final refreshed = await getAllNotes();
    refreshed.fold(
      (error) => emit(NotesError(error.toString())),
      (notes) => emit(NotesLoaded(notes)),
    );
  }

  Future<void> _onSortByImportance(
    SortByImportance event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    final result = await sortNotesByImportance();
    result.fold(
      (error) => emit(NotesError(error.toString())),
      (notes) => emit(NotesLoaded(notes)),
    );
  }

  Future<void> _onShareNote(
    ShareNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    final result = await getNoteById(event.id);
    if (result.isLeft()) {
      result.fold((error) => emit(NotesError(error.toString())), (_) {});
      return;
    }

    final note = result.fold((_) => null, (note) => note);
    if (note == null) {
      emit(const NotesError('Failed to load note for sharing'));
      return;
    }

    try {
      await shareNote(title: note.title, content: note.content);
      emit(NoteShared());
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _onCopyToClipboard(
    CopyNoteToClipboard event,
    Emitter<NotesState> emit,
  ) async {
    final result = await getNoteById(event.id);
    if (result.isLeft()) {
      result.fold((error) => emit(NotesError(error.toString())), (_) {});
      return;
    }

    final note = result.fold((_) => null, (note) => note);
    if (note == null) {
      emit(const NotesError('Failed to load note for copying'));
      return;
    }

    final copied = await clipboardHelper.copy(
      '${note.title}\n\n${note.content}',
    );
    if (copied) {
      emit(NoteCopied());
    } else {
      emit(const NotesError('Failed to copy to clipboard'));
    }
  }
}
