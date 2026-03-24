import 'package:equatable/equatable.dart';
import '../../models/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {
  final String uid;
  const LoadTasks(this.uid);

  @override
  List<Object> get props => [uid];
}

class UpdateTasksSubscription extends TaskEvent {
  final List<Task> tasks;
  const UpdateTasksSubscription(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class AddTask extends TaskEvent {
  final Task task;
  const AddTask(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;
  const UpdateTask(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String taskId;
  const DeleteTask(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class ToggleTask extends TaskEvent {
  final String taskId;
  final bool currentStatus;
  const ToggleTask(this.taskId, this.currentStatus);

  @override
  List<Object> get props => [taskId, currentStatus];
}
