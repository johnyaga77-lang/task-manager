import 'package:equatable/equatable.dart';
import '../../models/note_model.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class LoadNotes extends NoteEvent {
  final String uid;
  const LoadNotes(this.uid);

  @override
  List<Object> get props => [uid];
}

class UpdateNotesSubscription extends NoteEvent {
  final List<Note> notes;
  const UpdateNotesSubscription(this.notes);

  @override
  List<Object> get props => [notes];
}

class AddNote extends NoteEvent {
  final Note note;
  const AddNote(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateNote extends NoteEvent {
  final Note note;
  const UpdateNote(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteNote extends NoteEvent {
  final String noteId;
  const DeleteNote(this.noteId);

  @override
  List<Object> get props => [noteId];
}
