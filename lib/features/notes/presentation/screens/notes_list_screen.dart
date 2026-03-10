import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:codivium_notes_app/core/di/injection_container.dart';
import 'package:codivium_notes_app/core/routes/app_routes.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_event.dart';
import 'package:codivium_notes_app/features/notes/presentation/bloc/notes_state.dart';
import 'package:codivium_notes_app/features/calendar/presentation/widgets/horizontal_date_picker.dart';
import 'package:codivium_notes_app/features/calendar/presentation/widgets/category_filter_chip.dart';
import 'package:codivium_notes_app/features/notes/presentation/widgets/note_sliver_grid.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  late NotesBloc _notesBloc;
  DateTime _selectedDate = DateTime.now();
  int _selectedFilterIndex = 0;
  bool _sortedByImportance = false;

  final List<String> _filters = [
    'All',
    'Important',
    'Favorites',
    'To-do lists',
    'Recent',
  ];

  @override
  void initState() {
    super.initState();
    _notesBloc = sl<NotesBloc>();
    _loadNotes();
  }

  void _loadNotes() {
    if (_sortedByImportance) {
      _notesBloc.add(SortByImportance());
    } else {
      _notesBloc.add(LoadNotes());
    }
  }

  @override
  void dispose() {
    _notesBloc.close();
    super.dispose();
  }

  List<Note> _applyFilter(List<Note> notes) {
    switch (_selectedFilterIndex) {
      case 1:
        return notes.where((n) => n.importance >= 2).toList();
      case 2:
        return notes.where((n) => n.isFavorite).toList();
      case 3:
        return notes
            .where(
              (n) =>
                  n.content.contains('1.') ||
                  n.content.contains('•') ||
                  n.content.contains('- '),
            )
            .toList();
      case 4:
        final sorted = List<Note>.from(notes);
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return sorted.take(10).toList();
      default:
        return notes;
    }
  }

  void _showSortMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.sort),
                title: const Text('Sort by date'),
                trailing: !_sortedByImportance
                    ? const Icon(Icons.check, color: Colors.black)
                    : null,
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _sortedByImportance = false);
                  _notesBloc.add(LoadNotes());
                },
              ),
              ListTile(
                leading: const Icon(Icons.priority_high),
                title: const Text('Sort by importance'),
                trailing: _sortedByImportance
                    ? const Icon(Icons.check, color: Colors.black)
                    : null,
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _sortedByImportance = true);
                  _notesBloc.add(SortByImportance());
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(Note note) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete note?'),
          content: Text('Are you sure you want to delete "${note.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _notesBloc.add(RemoveNote(note.id));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _notesBloc,
      child: BlocListener<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NoteCopied) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied to clipboard')),
            );
          }
          if (state is NoteShared) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Note shared')));
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: RefreshIndicator.adaptive(
              onRefresh: () async {
                _loadNotes();
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildSearchBar()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: HorizontalDatePicker(
                        selectedDate: _selectedDate,
                        onDateSelected: (date) {
                          setState(() => _selectedDate = date);
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: _buildFilterChips(),
                    ),
                  ),
                  BlocBuilder<NotesBloc, NotesState>(
                    builder: (context, state) {
                      if (state is NotesLoading) {
                        return const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (state is NotesError) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  state.message,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: _loadNotes,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      if (state is NotesLoaded) {
                        final filtered = _applyFilter(state.notes);
                        if (filtered.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.note_outlined,
                                    size: 56,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No notes yet',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tap + to create one',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return NoteSliverGrid(
                          notes: filtered,
                          onNoteTap: (note) async {
                            await Get.toNamed(
                              noteEditorScreen,
                              arguments: note.id,
                            );
                            _loadNotes();
                          },
                          onNoteLongPress: (note) => _confirmDelete(note),
                        );
                      }
                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Get.toNamed(noteEditorScreen);
              _loadNotes();
            },
            backgroundColor: Colors.black,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: GestureDetector(
        onTap: () => Get.toNamed(searchScreen),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey.shade500, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Search for notes',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              ),
              GestureDetector(
                onTap: _showSortMenu,
                child: Icon(
                  Icons.tune_rounded,
                  color: Colors.grey.shade700,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return CategoryFilterChip(
            label: _filters[index],
            isSelected: _selectedFilterIndex == index,
            onTap: () {
              setState(() => _selectedFilterIndex = index);
            },
          );
        },
      ),
    );
  }
}
