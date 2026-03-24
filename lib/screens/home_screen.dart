import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/tasks/task_bloc.dart';
import '../blocs/tasks/task_state.dart';
import '../blocs/nav/nav_cubit.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'notes_view.dart';
import 'add_note_screen.dart';
import 'profile_screen.dart';
import 'commerce/home_commerce_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 4 Views now
    final List<Widget> views = [
      TasksView(),
      NotesView(),
      HomeCommerceScreen(),
      ProfileScreen(),
    ];

    return BlocBuilder<NavCubit, int>(
      builder: (context, selectedIndex) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: IndexedStack(index: selectedIndex, children: views),
          ),
          // FAB only shown for Tasks (0) and Notes (1)
          floatingActionButton: selectedIndex < 2
              ? FloatingActionButton.extended(
                  onPressed: () {
                    if (selectedIndex == 0) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => AddTaskScreen.create(context),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddNoteScreen.create(context),
                        ),
                      );
                    }
                  },
                  label: Text(selectedIndex == 0 ? 'New Task' : 'New Note'),
                  icon: const Icon(Icons.add),
                )
              : null,
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              context.read<NavCubit>().setIndex(index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.task_alt_outlined),
                selectedIcon: Icon(Icons.task_alt),
                label: 'Tasks',
              ),
              NavigationDestination(
                icon: Icon(Icons.note_alt_outlined),
                selectedIcon: Icon(Icons.note_alt),
                label: 'Notes',
              ),
              NavigationDestination(
                icon: Icon(Icons.store),
                selectedIcon: Icon(Icons.store),
                label: 'Shops',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TaskError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is TaskLoaded) {
          final suggestions = state.dailySuggestions;
          final allTasks = state.tasks;

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Header
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        String? photoUrl;
                        if (state is Authenticated) {
                          photoUrl = state.user.photoURL;
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, There!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Here are your daily updates',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                context.read<NavCubit>().setIndex(
                                  3,
                                ); // Go to Profile
                              },
                              child: CircleAvatar(
                                radius: 24,
                                backgroundImage: photoUrl != null
                                    ? NetworkImage(photoUrl)
                                    : null,
                                child: photoUrl == null
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                            ),
                          ],
                        );
                      },
                    ).animate().fadeIn().slideY(),
                    const SizedBox(height: 24),

                    // Suggestions Section
                    if (suggestions.isNotEmpty) ...[
                      Text(
                        'Daily Suggestions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 140, // Fixed height for suggestion cards
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: suggestions.length,
                          itemBuilder: (context, index) {
                            final task = suggestions[index];
                            return Container(
                              width: 280,
                              margin: const EdgeInsets.only(right: 12),
                              child: TaskCard(
                                task: task,
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => AddTaskScreen.create(
                                      context,
                                      taskToEdit: task,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                      const SizedBox(height: 24),
                    ],

                    // All Tasks Header
                    Text(
                      'All Tasks',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ]),
                ),
              ),

              // All Tasks List
              allTasks.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.task_alt,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No tasks yet!\nTap + to add one.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final task = allTasks[index];
                          return TaskCard(
                            task: task,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => AddTaskScreen.create(
                                  context,
                                  taskToEdit: task,
                                ),
                              );
                            },
                          );
                        }, childCount: allTasks.length),
                      ),
                    ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
