import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../services/firestore_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  StreamSubscription<List<Task>>? _tasksSubscription;
  FirestoreService? _firestoreService;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  TaskProvider() {
    _init();
  }

  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _tasksSubscription?.cancel();
      if (user != null) {
        _firestoreService = FirestoreService(uid: user.uid);
        _isLoading = true;
        notifyListeners();

        _tasksSubscription = _firestoreService!.getTasksStream().listen(
          (tasks) {
            _tasks = tasks;
            _isLoading = false;
            notifyListeners();
          },
          onError: (error) {
            debugPrint("Error listening to task stream: $error");
            _isLoading = false;
            notifyListeners();
          },
        );
      } else {
        _tasks = [];
        _firestoreService = null;
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }

  // Daily Suggestions logic (Client-side filtering for simplicity)
  List<Task> get dailySuggestions {
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);

    return _tasks.where((task) {
      if (task.isCompleted) return false;

      final taskDateStr = DateFormat('yyyy-MM-dd').format(task.date);
      final isToday = taskDateStr == todayStr;

      // Simple logic: Suggest if it's today, or if it's high importance and in the past (overdue)
      final isOverdue = task.date.isBefore(
        now.subtract(const Duration(days: 1)),
      );

      return isToday || (isOverdue && task.importance == TaskImportance.high);
    }).toList();
  }

  List<Task> getTasksByCategory(TaskCategory category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  Future<void> addTask(Task task) async {
    await _firestoreService?.addTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _firestoreService?.updateTask(task);
  }

  Future<void> deleteTask(String taskId) async {
    await _firestoreService?.deleteTask(taskId);
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    // Find task to get current status, though service could handle this if passed,
    // but the service method signature I created expects currentStatus.
    // Ideally, we should just toggle in firestore transaction or send the new value.
    // The service method toggleTaskCompletion(id, currentStatus) was defined previously.
    final task = _tasks.firstWhere((t) => t.id == taskId);
    await _firestoreService?.toggleTaskCompletion(taskId, task.isCompleted);
  }
}
