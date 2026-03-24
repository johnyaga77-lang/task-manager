import 'dart:ui';
import 'package:uuid/uuid.dart';

class Note {
  final String id;
  String title;
  String content;
  final DateTime date;
  Color? color;

  Note({
    String? id,
    required this.title,
    required this.content,
    required this.date,
    this.color,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'color': color?.value,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      color: json['color'] != null ? Color(json['color']) : null,
    );
  }

  Note copyWith({
    String? title,
    String? content,
    DateTime? date,
    Color? color,
  }) {
    return Note(
      id: this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      color: color ?? this.color,
    );
  }
}
