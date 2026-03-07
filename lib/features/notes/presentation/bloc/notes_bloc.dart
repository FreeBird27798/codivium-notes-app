import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_event.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitial()) {
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

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {}

  Future<void> _onLoadNoteById(LoadNoteById event, Emitter<NotesState> emit) async {}

  Future<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {}

  Future<void> _onEditNote(EditNote event, Emitter<NotesState> emit) async {}

  Future<void> _onRemoveNote(RemoveNote event, Emitter<NotesState> emit) async {}

  Future<void> _onToggleFavorite(ToggleNoteFavorite event, Emitter<NotesState> emit) async {}

  Future<void> _onSortByImportance(SortByImportance event, Emitter<NotesState> emit) async {}

  Future<void> _onShareNote(ShareNoteEvent event, Emitter<NotesState> emit) async {}

  Future<void> _onCopyToClipboard(CopyNoteToClipboard event, Emitter<NotesState> emit) async {}
}

