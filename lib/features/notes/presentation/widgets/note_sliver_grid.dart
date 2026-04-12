import 'package:flutter/material.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/presentation/widgets/note_card.dart';

class NoteSliverGrid extends StatelessWidget {
  final List<Note> notes;
  final void Function(Note note)? onNoteTap;
  final void Function(Note note)? onNoteLongPress;

  const NoteSliverGrid({
    super.key,
    required this.notes,
    this.onNoteTap,
    this.onNoteLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: _MasonrySliverList(
        notes: notes,
        onNoteTap: onNoteTap,
        onNoteLongPress: onNoteLongPress,
      ),
    );
  }
}

class _MasonrySliverList extends StatelessWidget {
  final List<Note> notes;
  final void Function(Note note)? onNoteTap;
  final void Function(Note note)? onNoteLongPress;

  const _MasonrySliverList({
    required this.notes,
    this.onNoteTap,
    this.onNoteLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final leftNotes = <Note>[];
    final rightNotes = <Note>[];
    double leftHeight = 0;
    double rightHeight = 0;

    for (final note in notes) {
      final estimatedHeight = _estimateCardHeight(note);
      if (leftHeight <= rightHeight) {
        leftNotes.add(note);
        leftHeight += estimatedHeight + 12;
      } else {
        rightNotes.add(note);
        rightHeight += estimatedHeight + 12;
      }
    }

    return SliverToBoxAdapter(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildColumn(leftNotes)),
          const SizedBox(width: 12),
          Expanded(child: _buildColumn(rightNotes)),
        ],
      ),
    );
  }

  Widget _buildColumn(List<Note> columnNotes) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: columnNotes.map((note) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NoteCard(
            note: note,
            onTap: () => onNoteTap?.call(note),
            onLongPress: () => onNoteLongPress?.call(note),
          ),
        );
      }).toList(),
    );
  }

  double _estimateCardHeight(Note note) {
    const padding = 28.0;
    const titleLineHeight = 20.0;
    const spacing = 8.0;
    const contentLineHeight = 19.2;
    const avgCharsPerLine = 28;

    double height = padding;

    final titleLines = (note.title.length / avgCharsPerLine).ceil().clamp(1, 2);
    height += titleLines * titleLineHeight;

    if (note.content.isNotEmpty) {
      height += spacing;
      final contentLines = (note.content.length / avgCharsPerLine).ceil().clamp(
        1,
        20,
      );
      final newLineCount = '\n'.allMatches(note.content).length;
      final totalLines = (contentLines + newLineCount).clamp(1, 20);
      height += totalLines * contentLineHeight;
    }

    return height;
  }
}
