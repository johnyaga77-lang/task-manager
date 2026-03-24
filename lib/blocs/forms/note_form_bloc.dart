import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart'; // For Colors.amber
import 'note_form_event.dart';
import 'note_form_state.dart';
import '../../models/note_model.dart';
import '../notes/note_bloc.dart';
import '../notes/note_event.dart';

class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  final NoteBloc _noteBloc;

  NoteFormBloc({required NoteBloc noteBloc})
    : _noteBloc = noteBloc,
      super(NoteFormState.initial()) {
    on<NoteFormInitialized>(_onInitialized);
    on<NoteTitleChanged>(_onTitleChanged);
    on<NoteContentChanged>(_onContentChanged);
    on<NoteFormSubmitted>(_onSubmitted);
  }

  void _onInitialized(NoteFormInitialized event, Emitter<NoteFormState> emit) {
    if (event.note != null) {
      emit(
        state.copyWith(
          title: event.note!.title,
          content: event.note!.content,
          initialId: event.note!.id,
          status: NoteFormStatus.updated,
        ),
      );
    } else {
      emit(NoteFormState.initial());
    }
  }

  void _onTitleChanged(NoteTitleChanged event, Emitter<NoteFormState> emit) {
    emit(state.copyWith(title: event.title, status: NoteFormStatus.updated));
  }

  void _onContentChanged(
    NoteContentChanged event,
    Emitter<NoteFormState> emit,
  ) {
    emit(
      state.copyWith(content: event.content, status: NoteFormStatus.updated),
    );
  }

  void _onSubmitted(NoteFormSubmitted event, Emitter<NoteFormState> emit) {
    if (!state.isValid) return;

    final note = Note(
      id: state.initialId,
      title: state.title,
      content: state.content,
      date: DateTime.now(),
      color: Colors.amber.shade100,
    );

    if (state.initialId != null) {
      _noteBloc.add(UpdateNote(note));
    } else {
      _noteBloc.add(AddNote(note));
    }

    emit(state.copyWith(status: NoteFormStatus.success));
  }
}
