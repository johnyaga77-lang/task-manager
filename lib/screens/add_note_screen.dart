import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/note_model.dart';
import '../blocs/forms/note_form_bloc.dart';
import '../blocs/forms/note_form_event.dart';
import '../blocs/forms/note_form_state.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  static Widget create(BuildContext context, {Note? noteToEdit}) {
    return BlocProvider(
      create: (context) =>
          NoteFormBloc(noteBloc: context.read())
            ..add(NoteFormInitialized(noteToEdit)),
      child: const AddNoteScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormBloc, NoteFormState>(
      listener: (context, state) {
        if (state.status == NoteFormStatus.success) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<NoteFormBloc, NoteFormState>(
            buildWhen: (p, c) => p.initialId != c.initialId,
            builder: (context, state) {
              return Text(state.initialId != null ? 'Edit Note' : 'New Note');
            },
          ),
          actions: [
            BlocBuilder<NoteFormBloc, NoteFormState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: state.isValid
                      ? () => context.read<NoteFormBloc>().add(
                          NoteFormSubmitted(),
                        )
                      : null,
                  icon: const Icon(Icons.check),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BlocBuilder<NoteFormBloc, NoteFormState>(
                buildWhen: (p, c) =>
                    p.initialId !=
                    c.initialId, // Only build once for initial value
                builder: (context, state) {
                  return TextFormField(
                    initialValue: state.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => context.read<NoteFormBloc>().add(
                      NoteTitleChanged(value),
                    ),
                  );
                },
              ),
              Expanded(
                child: BlocBuilder<NoteFormBloc, NoteFormState>(
                  buildWhen: (p, c) => p.initialId != c.initialId,
                  builder: (context, state) {
                    return TextFormField(
                      initialValue: state.content,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Start typing...',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => context.read<NoteFormBloc>().add(
                        NoteContentChanged(value),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
