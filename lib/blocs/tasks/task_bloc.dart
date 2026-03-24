import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/firestore_service.dart';
import 'task_event.dart';
import 'task_state.dart';
import '../../models/task_model.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  FirestoreService? _firestoreService;
  StreamSubscription<List<Task>>? _tasksSubscription;

  TaskBloc() : super(TaskLoading()) {
    on<LoadTasks>(_onLoadTasks);
    on<UpdateTasksSubscription>(_onUpdateTasksSubscription);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTask>(_onToggleTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    _tasksSubscription?.cancel();
    _firestoreService = FirestoreService(uid: event.uid);
    emit(TaskLoading());

    debugPrint('TaskBloc: Loading tasks for uid: ${event.uid}');

    _tasksSubscription = _firestoreService!.getTasksStream().listen(
      (tasks) {
        debugPrint('TaskBloc: Loaded ${tasks.length} tasks');
        add(UpdateTasksSubscription(tasks));
      },
      onError: (error) {
        debugPrint('TaskBloc: Error loading tasks: $error');
        // emit(TaskError(error.toString())); // We can't emit here, we must add an event
      },
    );
  }

  void _onUpdateTasksSubscription(
    UpdateTasksSubscription event,
    Emitter<TaskState> emit,
  ) {
    emit(TaskLoaded(event.tasks));
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      debugPrint('TaskBloc: Adding task to Firestore: ${event.task.title}');
      await _firestoreService?.addTask(event.task);
      debugPrint('TaskBloc: Task added successfully');
    } catch (e) {
      debugPrint('TaskBloc: Error adding task: $e');
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await _firestoreService?.updateTask(event.task);
    } catch (e) {
      debugPrint('TaskBloc: Error updating task: $e');
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await _firestoreService?.deleteTask(event.taskId);
    } catch (e) {
      debugPrint('TaskBloc: Error deleting task: $e');
    }
  }

  Future<void> _onToggleTask(ToggleTask event, Emitter<TaskState> emit) async {
    try {
      await _firestoreService?.toggleTaskCompletion(
        event.taskId,
        event.currentStatus,
      );
    } catch (e) {
      debugPrint('TaskBloc: Error toggling task: $e');
    }
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
