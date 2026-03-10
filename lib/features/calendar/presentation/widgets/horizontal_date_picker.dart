import 'package:flutter/material.dart';
import 'package:codivium_notes_app/features/calendar/presentation/widgets/calendar_day_widget.dart';

class HorizontalDatePicker extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const HorizontalDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<HorizontalDatePicker> createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends State<HorizontalDatePicker> {
  late ScrollController _scrollController;
  late DateTime _anchorDate;

  static const double _itemWidth = 66.0;
  static const Key _centerKey = ValueKey('center');

  @override
  void initState() {
    super.initState();
    _anchorDate = _stripTime(widget.selectedDate);
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected();
    });
  }

  DateTime _stripTime(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  void _scrollToSelected() {
    if (!_scrollController.hasClients) return;
    final diff = _stripTime(widget.selectedDate).difference(_anchorDate).inDays;
    final screenWidth = MediaQuery.of(context).size.width;
    final target = (diff * _itemWidth) - (screenWidth / 2) + (_itemWidth / 2);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void didUpdateWidget(HorizontalDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelected();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: CustomScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        center: _centerKey,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final date = _anchorDate.subtract(Duration(days: index + 1));
                return _buildDay(date);
              },
            ),
          ),
          SliverList(
            key: _centerKey,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final date = _anchorDate.add(Duration(days: index));
                return _buildDay(date);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDay(DateTime date) {
    final selected = _stripTime(widget.selectedDate);
    final isSelected = date.year == selected.year &&
        date.month == selected.month &&
        date.day == selected.day;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: CalendarDayWidget(
        date: date,
        isSelected: isSelected,
        onTap: () => widget.onDateSelected(date),
      ),
    );
  }
}

