import 'package:flutter/material.dart';

import '../lesson.dart';

class LessonListTile extends StatelessWidget {
  const LessonListTile({required this.lesson, required this.onTap, this.selected = false, super.key});

  final Lesson lesson;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Theme.of(context).colorScheme.primary : null;

    return ListTile(
      leading: Icon(selected ? Icons.play_circle_fill : Icons.play_circle_outline, color: color),
      title: Text(lesson.title, style: TextStyle(color: color)),
      subtitle: Text(lesson.description, maxLines: 2, overflow: TextOverflow.ellipsis),
      selected: selected,
      onTap: onTap,
    );
  }
}
