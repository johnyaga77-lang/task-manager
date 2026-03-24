import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/tasks/task_bloc.dart';
import '../../blocs/tasks/task_event.dart';
import '../../blocs/notes/note_bloc.dart';
import '../../blocs/notes/note_event.dart';
import '../home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Check initial state in case we missed the transition
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      debugPrint('AuthWrapper: Initially Authenticated. Loading data...');
      _loadData(state.user.uid);
    }
  }

  void _loadData(String uid) {
    context.read<TaskBloc>().add(LoadTasks(uid));
    context.read<NoteBloc>().add(LoadNotes(uid));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          debugPrint(
            'AuthWrapper: Auth State Changed to Authenticated. Loading data...',
          );
          _loadData(state.user.uid);
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          return const HomeScreen();
        }
        // Show LoginScreen for Unauthenticated, AuthError, AND AuthLoading.
        return const LoginScreen();
      },
    );
  }
}
