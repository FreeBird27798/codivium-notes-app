import 'package:flutter/material.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/core/constants/note_colors.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = Color(note.color);
    final titleColor = NoteColors.getTextColor(note.color);
    final contentColor = NoteColors.getSubtextColor(note.color);

    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(titleColor),
              if (note.content.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildContent(contentColor),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color titleColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            note.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (note.isFavorite)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(
              Icons.favorite,
              size: 14,
              color: titleColor.withValues(alpha: 0.6),
            ),
          ),
      ],
    );
  }

  Widget _buildContent(Color contentColor) {
    final lines = note.content.split('\n');
    final hasNumberedList = lines.length > 1 &&
        lines.any((line) => RegExp(r'^\d+\.').hasMatch(line.trim()));
    final hasBulletList = lines.length > 1 &&
        lines.any(
          (line) =>
              line.trim().startsWith('•') || line.trim().startsWith('-'),
        );

    if (hasNumberedList || hasBulletList) {
      return _buildListContent(lines, contentColor);
    }

    return Text(
      note.content,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: contentColor,
        height: 1.6,
      ),
    );
  }

  Widget _buildListContent(List<String> lines, Color contentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: lines.where((line) => line.trim().isNotEmpty).map((line) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            line,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: contentColor,
              height: 1.5,
            ),
          ),
        );
      }).toList(),
    );
  }
}
