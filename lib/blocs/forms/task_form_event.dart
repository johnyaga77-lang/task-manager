import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../models/task_model.dart';

abstract class TaskFormEvent extends Equatable {
  const TaskFormEvent();

  @override
  List<Object?> get props => [];
}

class TaskFormInitialized extends TaskFormEvent {
  final Task? task;
  const TaskFormInitialized(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskTitleChanged extends TaskFormEvent {
  final String title;
  const TaskTitleChanged(this.title);

  @override
  List<Object?> get props => [title];
}

class TaskDateChanged extends TaskFormEvent {
  final DateTime date;
  const TaskDateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

class TaskTimeChanged extends TaskFormEvent {
  final TimeOfDay time;
  const TaskTimeChanged(this.time);

  @override
  List<Object?> get props => [time];
}

class TaskImportanceChanged extends TaskFormEvent {
  final TaskImportance importance;
  const TaskImportanceChanged(this.importance);

  @override
  List<Object?> get props => [importance];
}

class TaskCategoryChanged extends TaskFormEvent {
  final TaskCategory category;
  const TaskCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

class TaskFormSubmitted extends TaskFormEvent {}
