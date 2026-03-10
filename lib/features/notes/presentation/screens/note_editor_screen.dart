import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:codivium_notes_app/core/di/injection_container.dart';
import 'package:codivium_notes_app/core/constants/note_colors.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_event.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_state.dart';
import 'package:codivium_notes_app/features/notes/presentation/widgets/text_formatter_toolbar.dart';
import 'package:codivium_notes_app/features/notes/presentation/widgets/todo_list_widget.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/todo.dart';
import 'package:codivium_notes_app/features/notes/data/models/todo_model.dart';
import 'package:codivium_notes_app/features/notes/data/datasources/notes_local_datasource.dart';
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
  int _selectedColor = NoteColors.pastelPalette[0];
  int _importance = 1;
  String? _noteId;
  bool _isEditing = false;
  DateTime? _originalCreatedAt;
  List<Todo> _todos = [];
  List<Todo> _currentTodos = [];

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
      _loadTodos(_noteId!);
    } else {
      _noteId = const Uuid().v4();
    }
  }

  Future<void> _loadTodos(String noteId) async {
    final datasource = sl<NotesLocalDatasource>();
    final todos = await datasource.getTodosForNote(noteId);
    setState(() {
      _todos = todos;
      _currentTodos = List.from(todos);
    });
  }

  Future<void> _saveTodos(String noteId) async {
    final datasource = sl<NotesLocalDatasource>();

    final oldIds = _todos.map((t) => t.id).toSet();
    final newIds = _currentTodos.map((t) => t.id).toSet();

    for (final oldTodo in _todos) {
      if (!newIds.contains(oldTodo.id)) {
        await datasource.deleteTodo(oldTodo.id);
      }
    }

    for (final todo in _currentTodos) {
      final model = TodoModel(
        id: todo.id,
        noteId: noteId,
        text: todo.text,
        isDone: todo.isDone,
        order: todo.order,
      );
      if (oldIds.contains(todo.id)) {
        await datasource.updateTodo(model);
      } else {
        await datasource.insertTodo(model);
      }
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

  void _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    final now = DateTime.now();
    final id = _noteId ?? const Uuid().v4();

    if (_isEditing) {
      final updated = Note(
        id: id,
        title: title,
        content: content,
        color: _selectedColor,
        isFavorite: _isFavorite,
        importance: _importance,
        createdAt: _originalCreatedAt ?? now,
        updatedAt: now,
      );
      _notesBloc.add(EditNote(updated));
    } else {
      final newNote = Note(
        id: id,
        title: title,
        content: content,
        color: _selectedColor,
        isFavorite: _isFavorite,
        importance: _importance,
        createdAt: now,
        updatedAt: now,
      );
      _notesBloc.add(AddNote(newNote));
    }

    await _saveTodos(id);
    Get.back();
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pick a color',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: NoteColors.pastelPalette.map((color) {
                    final isSelected = color == _selectedColor;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedColor = color);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Color(color),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.black, width: 2.5)
                              : Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, size: 20)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showImportancePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Set importance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildImportanceOption(ctx, 1, 'Low', Icons.remove_circle_outline),
                _buildImportanceOption(ctx, 2, 'Medium', Icons.circle_outlined),
                _buildImportanceOption(ctx, 3, 'High', Icons.error_outline),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImportanceOption(
    BuildContext ctx,
    int value,
    String label,
    IconData icon,
  ) {
    final isSelected = _importance == value;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.black : Colors.grey),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: Colors.black)
          : null,
      onTap: () {
        setState(() => _importance = value);
        Navigator.pop(ctx);
      },
    );
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
              _selectedColor = state.note.color;
              _importance = state.note.importance;
              _originalCreatedAt = state.note.createdAt;
            });
          }
          if (state is NoteCopied) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied to clipboard')),
            );
          }
          if (state is NoteShared) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Note shared')),
            );
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
                            const SizedBox(height: 4),
                            _buildColorImportanceRow(),
                            const SizedBox(height: 8),
                            _buildTitleField(),
                            const SizedBox(height: 12),
                            _buildContentField(),
                            const SizedBox(height: 20),
                            TodoListWidget(
                              noteId: _noteId ?? '',
                              initialTodos: _todos,
                              onChanged: (todos) {
                                _currentTodos = todos;
                              },
                            ),
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
                  child: TextFormatterToolbar(
                    controller: _contentController,
                  ),
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
            icon: const Icon(Icons.check_rounded, size: 24),
          ),
          IconButton(
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
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

  Widget _buildColorImportanceRow() {
    final importanceLabels = {1: 'Low', 2: 'Medium', 3: 'High'};

    return Row(
      children: [
        GestureDetector(
          onTap: _showColorPicker,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Color(_selectedColor),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: const Icon(Icons.palette_outlined, size: 14),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _showImportancePicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _importance >= 3
                      ? Icons.error_outline
                      : _importance >= 2
                          ? Icons.circle_outlined
                          : Icons.remove_circle_outline,
                  size: 14,
                  color: Colors.black54,
                ),
                const SizedBox(width: 4),
                Text(
                  importanceLabels[_importance] ?? 'Low',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.arrow_drop_down, size: 16, color: Colors.black54),
              ],
            ),
          ),
        ),
        const Spacer(),
        if (_isEditing && _noteId != null)
          GestureDetector(
            onTap: () => _notesBloc.add(CopyNoteToClipboard(_noteId!)),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.copy_outlined,
                size: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ),
      ],
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
