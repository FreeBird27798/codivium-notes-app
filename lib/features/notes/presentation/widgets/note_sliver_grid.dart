import 'package:flutter/material.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/notes/presentation/widgets/note_card.dart';

class NoteSliverGrid extends StatelessWidget {
  final List<Note> notes;
  final void Function(Note note)? onNoteTap;

  const NoteSliverGrid({super.key, required this.notes, this.onNoteTap});

  @override
  Widget build(BuildContext context) {
    final leftColumn = <Note>[];
    final rightColumn = <Note>[];

    for (int i = 0; i < notes.length; i++) {
      if (i.isEven) {
        leftColumn.add(notes[i]);
      } else {
        rightColumn.add(notes[i]);
      }
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: leftColumn.map((note) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NoteCard(
                      note: note,
                      onTap: () => onNoteTap?.call(note),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: rightColumn.map((note) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NoteCard(
                      note: note,
                      onTap: () => onNoteTap?.call(note),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
