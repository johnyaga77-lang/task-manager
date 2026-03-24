import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'task_form_event.dart';
import 'task_form_state.dart';
import '../../models/task_model.dart';
import '../tasks/task_bloc.dart';
import '../tasks/task_event.dart';

class TaskFormBloc extends Bloc<TaskFormEvent, TaskFormState> {
  final TaskBloc _taskBloc;

  TaskFormBloc({required TaskBloc taskBloc})
    : _taskBloc = taskBloc,
      super(TaskFormState.initial()) {
    on<TaskFormInitialized>(_onInitialized);
    on<TaskTitleChanged>(_onTitleChanged);
    on<TaskDateChanged>(_onDateChanged);
    on<TaskTimeChanged>(_onTimeChanged);
    on<TaskImportanceChanged>(_onImportanceChanged);
    on<TaskCategoryChanged>(_onCategoryChanged);
    on<TaskFormSubmitted>(_onSubmitted);
  }

  void _onInitialized(TaskFormInitialized event, Emitter<TaskFormState> emit) {
    final task = event.task;
    if (task != null) {
      emit(
        state.copyWith(
          title: task.title,
          date: task.date,
          time: TimeOfDay.fromDateTime(task.date),
          importance: task.importance,
          category: task.category,
          initialId: task.id,
          status: TaskFormStatus.updated,
        ),
      );
    } else {
      emit(TaskFormState.initial());
    }
  }

  void _onTitleChanged(TaskTitleChanged event, Emitter<TaskFormState> emit) {
    emit(state.copyWith(title: event.title, status: TaskFormStatus.updated));
  }

  void _onDateChanged(TaskDateChanged event, Emitter<TaskFormState> emit) {
    emit(state.copyWith(date: event.date, status: TaskFormStatus.updated));
  }

  void _onTimeChanged(TaskTimeChanged event, Emitter<TaskFormState> emit) {
    emit(state.copyWith(time: event.time, status: TaskFormStatus.updated));
  }

  void _onImportanceChanged(
    TaskImportanceChanged event,
    Emitter<TaskFormState> emit,
  ) {
    emit(
      state.copyWith(
        importance: event.importance,
        status: TaskFormStatus.updated,
      ),
    );
  }

  void _onCategoryChanged(
    TaskCategoryChanged event,
    Emitter<TaskFormState> emit,
  ) {
    emit(
      state.copyWith(category: event.category, status: TaskFormStatus.updated),
    );
  }

  void _onSubmitted(TaskFormSubmitted event, Emitter<TaskFormState> emit) {
    if (state.title.isEmpty) return;

    final date = DateTime(
      state.date.year,
      state.date.month,
      state.date.day,
      state.time.hour,
      state.time.minute,
    );

    final task = Task(
      id: state.initialId,
      title: state.title,
      description: '',
      date: date,
      importance: state.importance,
      category: state.category,
      isCompleted:
          false, // Preserved in update via ID usually, but here strict rewrite
    );

    if (state.initialId != null) {
      _taskBloc.add(UpdateTask(task));
    } else {
      _taskBloc.add(AddTask(task));
    }

    emit(state.copyWith(status: TaskFormStatus.success));
  }
}
