import 'package:flutter/material.dart';
import '../models/task_model.dart';

class ImportanceBadge extends StatelessWidget {
  final TaskImportance importance;
  final bool small;

  const ImportanceBadge({
    super.key,
    required this.importance,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (importance) {
      case TaskImportance.high:
        color = Colors.redAccent;
        label = 'High';
        break;
      case TaskImportance.medium:
        color = Colors.orangeAccent;
        label = 'Medium';
        break;
      case TaskImportance.low:
        color = Colors.greenAccent;
        label = 'Low';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 12,
        vertical: small ? 2 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: small ? 10 : 12,
        ),
      ),
    );
  }
}
