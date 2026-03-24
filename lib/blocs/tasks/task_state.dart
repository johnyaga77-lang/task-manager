import 'package:equatable/equatable.dart';
import '../../models/task_model.dart';
import 'package:intl/intl.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;

  const TaskLoaded([this.tasks = const []]);

  List<Task> get dailySuggestions {
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);

    return tasks.where((task) {
      if (task.isCompleted) return false;

      final taskDateStr = DateFormat('yyyy-MM-dd').format(task.date);
      final isToday = taskDateStr == todayStr;
      final isOverdue = task.date.isBefore(
        now.subtract(const Duration(days: 1)),
      );

      return isToday || (isOverdue && task.importance == TaskImportance.high);
    }).toList();
  }

  List<Task> getTasksByCategory(TaskCategory category) {
    return tasks.where((task) => task.category == category).toList();
  }

  @override
  List<Object> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}
