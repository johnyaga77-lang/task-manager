import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../blocs/notes/note_bloc.dart';
import '../blocs/notes/note_state.dart';
import 'add_note_screen.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        if (state is NoteLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NoteError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is NoteLoaded) {
          final notes = state.notes;

          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notes yet!',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AddNoteScreen.create(context, noteToEdit: note),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: note.color ?? Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (note.title.isNotEmpty) ...[
                          Text(
                            note.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        Text(
                          note.content,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
