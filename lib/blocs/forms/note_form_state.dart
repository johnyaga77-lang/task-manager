import 'package:equatable/equatable.dart';

enum NoteFormStatus { initial, updated, submitting, success, failure }

class NoteFormState extends Equatable {
  final String title;
  final String content;
  final NoteFormStatus status;
  final String? initialId; // If editing

  const NoteFormState({
    required this.title,
    required this.content,
    required this.status,
    this.initialId,
  });

  factory NoteFormState.initial() {
    return const NoteFormState(
      title: '',
      content: '',
      status: NoteFormStatus.initial,
    );
  }

  NoteFormState copyWith({
    String? title,
    String? content,
    NoteFormStatus? status,
    String? initialId,
  }) {
    return NoteFormState(
      title: title ?? this.title,
      content: content ?? this.content,
      status: status ?? this.status,
      initialId: initialId ?? this.initialId,
    );
  }

  bool get isValid => title.isNotEmpty || content.isNotEmpty;

  @override
  List<Object?> get props => [title, content, status, initialId];
}
