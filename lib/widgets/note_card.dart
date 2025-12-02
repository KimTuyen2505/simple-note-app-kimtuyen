import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';

Color tagColor(String tag) {
  switch (tag) {
    case 'Work':
      return const Color(0xFF1E6DE5);
    case 'Contacts':
      return const Color(0xFF0D8A6A);
    case 'Shopping':
      return const Color(0xFFC97A2B);
    case 'Books':
      return const Color(0xFF7A1212);
    case 'Meeting':
      return const Color(0xFF2E3A59);
    default:
      return const Color(0xFF3A3F5C);
  }
}

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = tagColor(note.tag);
    final date = DateFormat('dd/MM/yyyy').format(note.updatedAt);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: c.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 70,
              decoration: BoxDecoration(
                color: c,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title.isEmpty ? '(No title)' : note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (note.pinned)
                        const Text('📌', style: TextStyle(fontSize: 16)),
                      if (note.locked)
                        const Text(' 🔒', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
