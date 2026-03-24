import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../utils/snackbar_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signup() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showTopSnackBar(context, 'Please fill in all fields.');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      showTopSnackBar(context, 'Invalid email address.');
      return;
    }

    if (password.length < 6) {
      showTopSnackBar(context, 'Password must be at least 6 characters.');
      return;
    }

    context.read<AuthBloc>().add(SignupRequested(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            showTopSnackBar(context, state.message);
          }
          // Navigation back to login or auto-login is handled by the AuthWrapper re-rendering
          // But if we pushed this screen, we might want to pop.
          // However, if signup succeeds, AuthBloc state becomes Authenticated.
          // AuthWrapper (at the root) sees this and replaces the whole view with HomeScreen.
          // So we probably don't need manual navigation unless we want to "Go back" to login.
          // If we're on top of LoginScreen, AuthWrapper will rebuild LoginScreen -> HomeScreen swap.
          // But since SignupScreen is PUSHED, we should probably POP it if we are authenticated,
          // OR AuthWrapper is above the Navigator so it rebuilds the whole tree?
          // Actually AuthWrapper is the 'home' of MaterialApp.
          // When state changes to Authenticated, AuthWrapper switches to HomeScreen.
          // The Navigator stack (Login -> Signup) is destroyed because AuthWrapper rebuilds the root widget.
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return FilledButton(
                      onPressed: _signup,
                      child: const Text('Sign Up'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
