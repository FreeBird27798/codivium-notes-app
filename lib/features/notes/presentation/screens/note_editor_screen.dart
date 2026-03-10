import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:codivium_notes_app/core/di/injection_container.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_event.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_state.dart';
import 'package:codivium_notes_app/features/notes/presentation/widgets/text_formatter_toolbar.dart';
import 'package:uuid/uuid.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late NotesBloc _notesBloc;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late FocusNode _contentFocusNode;
  bool _isFavorite = false;
  String? _noteId;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _notesBloc = sl<NotesBloc>();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _contentFocusNode = FocusNode();

    final args = Get.arguments;
    if (args is String) {
      _noteId = args;
      _isEditing = true;
      _notesBloc.add(LoadNoteById(_noteId!));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contentFocusNode.dispose();
    _notesBloc.close();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    if (_isEditing && _noteId != null) {
      final updated = Note(
        id: _noteId!,
        title: title,
        content: content,
        color: 0xFFFFEB3B,
        isFavorite: _isFavorite,
        importance: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _notesBloc.add(EditNote(updated));
    } else {
      final newNote = Note(
        id: const Uuid().v4(),
        title: title,
        content: content,
        color: 0xFFFFEB3B,
        isFavorite: _isFavorite,
        importance: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _notesBloc.add(AddNote(newNote));
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _notesBloc,
      child: BlocListener<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NoteDetailLoaded) {
            _titleController.text = state.note.title;
            _contentController.text = state.note.content;
            setState(() {
              _isFavorite = state.note.isFavorite;
            });
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildTopBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _buildTitleField(),
                            const SizedBox(height: 12),
                            _buildContentField(),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: TextFormatterToolbar(controller: _contentController),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, size: 24),
          ),
          const Spacer(),
          IconButton(
            onPressed: _saveNote,
            icon: const Icon(Icons.calendar_today_outlined, size: 22),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 22,
              color: _isFavorite ? Colors.red : Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              if (_noteId != null) {
                _notesBloc.add(ShareNoteEvent(_noteId!));
              }
            },
            icon: const Icon(Icons.ios_share_outlined, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        height: 1.3,
      ),
      decoration: const InputDecoration(
        hintText: 'Title',
        hintStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.grey,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildContentField() {
    return TextField(
      controller: _contentController,
      focusNode: _contentFocusNode,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
        height: 1.7,
      ),
      decoration: const InputDecoration(
        hintText: 'Start typing...',
        hintStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
    );
  }
}
