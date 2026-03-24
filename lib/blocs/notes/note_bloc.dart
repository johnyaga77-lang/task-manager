import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/firestore_service.dart';
import 'note_event.dart';
import 'note_state.dart';
import '../../models/note_model.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  FirestoreService? _firestoreService;
  StreamSubscription<List<Note>>? _notesSubscription;

  NoteBloc() : super(NoteLoading()) {
    on<LoadNotes>(_onLoadNotes);
    on<UpdateNotesSubscription>(_onUpdateNotesSubscription);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    _notesSubscription?.cancel();
    _firestoreService = FirestoreService(uid: event.uid);
    emit(NoteLoading());

    _notesSubscription = _firestoreService!.getNotesStream().listen(
      (notes) {
        add(UpdateNotesSubscription(notes));
      },
      onError: (error) {
        // Handle error
      },
    );
  }

  void _onUpdateNotesSubscription(
    UpdateNotesSubscription event,
    Emitter<NoteState> emit,
  ) {
    emit(NoteLoaded(event.notes));
  }

  Future<void> _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    try {
      await _firestoreService?.addNote(event.note);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    try {
      await _firestoreService?.updateNote(event.note);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    try {
      await _firestoreService?.deleteNote(event.noteId);
    } catch (e) {
      // Handle error
    }
  }

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }
}
