import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../models/task_model.dart';

enum TaskFormStatus { initial, updated, submitting, success, failure }

class TaskFormState extends Equatable {
  final String title;
  final DateTime date;
  final TimeOfDay time;
  final TaskImportance importance;
  final TaskCategory category;
  final TaskFormStatus status;
  final String? initialId; // If editing

  const TaskFormState({
    required this.title,
    required this.date,
    required this.time,
    required this.importance,
    required this.category,
    required this.status,
    this.initialId,
  });

  factory TaskFormState.initial() {
    final now = DateTime.now();
    return TaskFormState(
      title: '',
      date: now,
      time: TimeOfDay.fromDateTime(now),
      importance: TaskImportance.medium,
      category: TaskCategory.personal,
      status: TaskFormStatus.initial,
    );
  }

  TaskFormState copyWith({
    String? title,
    DateTime? date,
    TimeOfDay? time,
    TaskImportance? importance,
    TaskCategory? category,
    TaskFormStatus? status,
    String? initialId,
  }) {
    return TaskFormState(
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      importance: importance ?? this.importance,
      category: category ?? this.category,
      status: status ?? this.status,
      initialId: initialId ?? this.initialId,
    );
  }

  bool get isDateValid => title.isNotEmpty;

  @override
  List<Object?> get props => [
    title,
    date,
    time,
    importance,
    category,
    status,
    initialId,
  ];
}
