import 'package:uuid/uuid.dart';

enum TaskImportance { low, medium, high }

enum TaskCategory { personal, work, study, home, health, other }

class Task {
  final String id;
  String title;
  String description;
  final DateTime date;
  TaskImportance importance;
  TaskCategory category;
  bool isCompleted;

  Task({
    String? id,
    required this.title,
    required this.description,
    required this.date,
    required this.importance,
    required this.category,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();

  // Convert to Map for Shared Preferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'importance': importance.name,
      'category': category.name,
      'isCompleted': isCompleted,
    };
  }

  // Create from Map
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      importance: TaskImportance.values.firstWhere(
        (e) => e.name == json['importance'],
        orElse: () => TaskImportance.medium,
      ),
      category: TaskCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => TaskCategory.other,
      ),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Task copyWith({
    String? title,
    String? description,
    TaskImportance? importance,
    TaskCategory? category,
    bool? isCompleted,
  }) {
    return Task(
      id: this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: this.date,
      importance: importance ?? this.importance,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
