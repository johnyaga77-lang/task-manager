import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/tasks/task_bloc.dart';
import 'blocs/notes/note_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'blocs/nav/nav_cubit.dart';
import 'screens/auth/auth_wrapper.dart';
import 'utils/theme.dart';
import 'services/storage_service.dart';

import 'blocs/theme/theme_cubit.dart';
import 'blocs/cart/cart_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // repository provider is useful if we want to access AuthService elsewhere,
    // but for now strict dependency injection into Bloc is fine.
    // Creating AuthService once here.
    final authService = AuthService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              AuthBloc(authService: authService)..add(CheckAuthStatus()),
        ),
        BlocProvider<NavCubit>(create: (context) => NavCubit()),
        BlocProvider<TaskBloc>(create: (context) => TaskBloc()),
        BlocProvider<NoteBloc>(create: (context) => NoteBloc()),
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
            storageService: StorageService(),
            authService: authService,
          ),
        ),
        BlocProvider<CartBloc>(create: (context) => CartBloc()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Tasker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}
