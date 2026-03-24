import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task_model.dart';
import '../blocs/tasks/task_bloc.dart';
import '../blocs/tasks/task_event.dart';
import 'importance_badge.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Checkbox
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: task.isCompleted,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (val) {
                    context.read<TaskBloc>().add(
                      ToggleTask(task.id, task.isCompleted),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted ? Colors.grey : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const SizedBox(height: 4),
                    // Description removed for simplicity
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd, hh:mm a').format(task.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const Spacer(),
                        ImportanceBadge(
                          importance: task.importance,
                          small: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }
}
