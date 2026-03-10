import 'package:flutter/material.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/todo.dart';
import 'package:uuid/uuid.dart';

class TodoListWidget extends StatefulWidget {
  final String noteId;
  final List<Todo> initialTodos;
  final void Function(List<Todo> todos)? onChanged;

  const TodoListWidget({
    super.key,
    required this.noteId,
    this.initialTodos = const [],
    this.onChanged,
  });

  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  final List<Todo> _todos = [];
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    for (final todo in widget.initialTodos) {
      _todos.add(todo);
      _controllers[todo.id] = TextEditingController(text: todo.text);
      _focusNodes[todo.id] = FocusNode();
    }
  }

  @override
  void didUpdateWidget(covariant TodoListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTodos != oldWidget.initialTodos && _todos.isEmpty) {
      for (final todo in widget.initialTodos) {
        _todos.add(todo);
        _controllers[todo.id] = TextEditingController(text: todo.text);
        _focusNodes[todo.id] = FocusNode();
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _notifyChanged() {
    widget.onChanged?.call(List.unmodifiable(_todos));
  }

  void _addTodo() {
    final id = const Uuid().v4();
    final todo = Todo(
      id: id,
      noteId: widget.noteId,
      text: '',
      isDone: false,
      order: _todos.length,
    );
    _controllers[id] = TextEditingController();
    _focusNodes[id] = FocusNode();

    setState(() {
      _todos.add(todo);
    });
    _notifyChanged();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[id]?.requestFocus();
    });
  }

  void _removeTodo(int index) {
    final todo = _todos[index];
    _controllers[todo.id]?.dispose();
    _controllers.remove(todo.id);
    _focusNodes[todo.id]?.dispose();
    _focusNodes.remove(todo.id);

    setState(() {
      _todos.removeAt(index);
      _reorderIndexes();
    });
    _notifyChanged();
  }

  void _toggleTodo(int index) {
    final old = _todos[index];
    final updated = Todo(
      id: old.id,
      noteId: old.noteId,
      text: old.text,
      isDone: !old.isDone,
      order: old.order,
    );

    setState(() {
      _todos[index] = updated;
    });
    _notifyChanged();
  }

  void _updateText(int index, String text) {
    final old = _todos[index];
    _todos[index] = Todo(
      id: old.id,
      noteId: old.noteId,
      text: text,
      isDone: old.isDone,
      order: old.order,
    );
    _notifyChanged();
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;

    setState(() {
      final item = _todos.removeAt(oldIndex);
      _todos.insert(newIndex, item);
      _reorderIndexes();
    });
    _notifyChanged();
  }

  void _reorderIndexes() {
    for (int i = 0; i < _todos.length; i++) {
      final old = _todos[i];
      if (old.order != i) {
        _todos[i] = Todo(
          id: old.id,
          noteId: old.noteId,
          text: old.text,
          isDone: old.isDone,
          order: i,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        if (_todos.isNotEmpty) _buildList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.checklist_rounded, size: 18, color: Colors.black54),
          const SizedBox(width: 6),
          Text(
            'To-do (${_todos.where((t) => t.isDone).length}/${_todos.length})',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _addTodo,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 16, color: Colors.black54),
                  SizedBox(width: 2),
                  Text(
                    'Add',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          listenable: animation,
          builder: (context, child) {
            final scale = Tween<double>(begin: 1.0, end: 1.03).evaluate(animation);
            return Transform.scale(
              scale: scale,
              child: Material(
                color: Colors.transparent,
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: child,
              ),
            );
          },
          child: child,
        );
      },
      itemCount: _todos.length,
      onReorder: _onReorder,
      itemBuilder: (context, index) {
        final todo = _todos[index];
        return _buildTodoItem(todo, index);
      },
    );
  }

  Widget _buildTodoItem(Todo todo, int index) {
    final controller = _controllers[todo.id]!;
    final focusNode = _focusNodes[todo.id]!;

    return Container(
      key: ValueKey(todo.id),
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                Icons.drag_indicator,
                size: 18,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _toggleTodo(index),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: todo.isDone ? Colors.black : Colors.grey.shade400,
                  width: 1.5,
                ),
                color: todo.isDone ? Colors.black : Colors.transparent,
              ),
              child: todo.isDone
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: (text) => _updateText(index, text),
              style: TextStyle(
                fontSize: 14,
                color: todo.isDone ? Colors.grey : Colors.black87,
                decoration: todo.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
              decoration: const InputDecoration(
                hintText: 'New item',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 6),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _removeTodo(index),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
