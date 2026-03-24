import 'package:equatable/equatable.dart';
import '../../models/note_model.dart';

abstract class NoteFormEvent extends Equatable {
  const NoteFormEvent();

  @override
  List<Object?> get props => [];
}

class NoteFormInitialized extends NoteFormEvent {
  final Note? note;
  const NoteFormInitialized(this.note);

  @override
  List<Object?> get props => [note];
}

class NoteTitleChanged extends NoteFormEvent {
  final String title;
  const NoteTitleChanged(this.title);

  @override
  List<Object?> get props => [title];
}

class NoteContentChanged extends NoteFormEvent {
  final String content;
  const NoteContentChanged(this.content);

  @override
  List<Object?> get props => [content];
}

class NoteFormSubmitted extends NoteFormEvent {}
