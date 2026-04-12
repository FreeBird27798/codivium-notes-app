import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:codivium_notes_app/core/di/injection_container.dart';
import 'package:codivium_notes_app/core/routes/app_routes.dart';
import 'package:codivium_notes_app/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:codivium_notes_app/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:codivium_notes_app/features/calendar/presentation/bloc/calendar_state.dart';
import 'package:codivium_notes_app/features/calendar/presentation/widgets/horizontal_date_picker.dart';
import 'package:codivium_notes_app/features/calendar/presentation/widgets/category_filter_chip.dart';
import 'package:codivium_notes_app/features/notes/presentation/widgets/note_sliver_grid.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late CalendarBloc _calendarBloc;
  DateTime _selectedDate = DateTime.now();
  int _selectedFilterIndex = 0;

  final List<String> _filters = [
    'All',
    'Important',
    'Lecture notes',
    'To-do lists',
    'Shopping',
  ];

  @override
  void initState() {
    super.initState();
    _calendarBloc = sl<CalendarBloc>();
    _calendarBloc.add(SelectDate(_selectedDate));
  }

  @override
  void dispose() {
    _calendarBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _calendarBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: _buildSearchBar(context),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: HorizontalDatePicker(
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                      _calendarBloc.add(SelectDate(date));
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
              BlocBuilder<CalendarBloc, CalendarState>(
                builder: (context, state) {
                  if (state is CalendarLoading) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is CalendarError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }
                  if (state is CalendarLoaded) {
                    if (state.notes.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            'No notes for this date',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      );
                    }
                    return NoteSliverGrid(
                      notes: state.notes,
                      onNoteTap: (note) {
                        Get.toNamed(noteEditorScreen, arguments: note.id);
                      },
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(noteEditorScreen);
          },
          backgroundColor: Colors.black,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(searchScreen);
      },
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
            Text(
              'Search for notes',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
            const Spacer(),
            Icon(
              Icons.notifications_outlined,
              color: Colors.grey.shade700,
              size: 22,
            ),
          ],
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
              setState(() {
                _selectedFilterIndex = index;
              });
            },
          );
        },
      ),
    );
  }
}
