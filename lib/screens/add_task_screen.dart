import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../blocs/forms/task_form_bloc.dart';
import '../blocs/forms/task_form_event.dart';
import '../blocs/forms/task_form_state.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  static Widget create(BuildContext context, {Task? taskToEdit}) {
    return BlocProvider(
      create: (context) =>
          TaskFormBloc(taskBloc: context.read())
            ..add(TaskFormInitialized(taskToEdit)),
      child: const AddTaskScreen(),
    );
  }

  // Quick Suggestions Data
  static const Map<String, TaskCategory> _quickTasks = {
    'Morning Workout': TaskCategory.health,
    'Read a Book': TaskCategory.personal,
    'Grocery Shopping': TaskCategory.home,
    'Team Meeting': TaskCategory.work,
    'Study Session': TaskCategory.study,
    'Pay Bills': TaskCategory.other,
  };

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskFormBloc, TaskFormState>(
      listener: (context, state) {
        if (state.status == TaskFormStatus.success) {
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),

              // Header
              BlocBuilder<TaskFormBloc, TaskFormState>(
                buildWhen: (previous, current) =>
                    previous.initialId != current.initialId,
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.initialId != null ? 'Edit Task' : 'New Task',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Divider(),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Unified Title and Suggestion Field
                      _buildTitleField(context),
                      const SizedBox(height: 16),

                      // Date Picker
                      _buildDatePicker(context),
                      const Divider(),
                      const SizedBox(height: 8),

                      const Text(
                        'Importance',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildImportanceSelector(context),
                      const SizedBox(height: 16),

                      const Text(
                        'Category',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildCategorySelector(context),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: BlocBuilder<TaskFormBloc, TaskFormState>(
                          builder: (context, state) {
                            return FilledButton(
                              onPressed: state.title.isNotEmpty
                                  ? () => context.read<TaskFormBloc>().add(
                                      TaskFormSubmitted(),
                                    )
                                  : null,
                              child: const Text('Save Task'),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField(BuildContext context) {
    return BlocBuilder<TaskFormBloc, TaskFormState>(
      // Only rebuild if external reset needed (complex), usually managing own controller
      // For Strict Stateless with Autocomplete, we use the builder's controller
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Autocomplete<String>(
              initialValue: TextEditingValue(text: state.title),
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return _quickTasks.keys;
                }
                return _quickTasks.keys.where((String option) {
                  return option.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  );
                });
              },
              onSelected: (String selection) {
                context.read<TaskFormBloc>().add(TaskTitleChanged(selection));
                context.read<TaskFormBloc>().add(
                  TaskCategoryChanged(_quickTasks[selection]!),
                );
              },
              fieldViewBuilder:
                  (
                    BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    // We hook into the controller to send updates to Bloc
                    return TextFormField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Task Title / Suggestion',
                        hintText: 'Type or pick a suggestion...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flash_on),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      onChanged: (text) {
                        context.read<TaskFormBloc>().add(
                          TaskTitleChanged(text),
                        );
                      },
                    );
                  },
              optionsViewBuilder:
                  (
                    BuildContext context,
                    AutocompleteOnSelected<String> onSelected,
                    Iterable<String> options,
                  ) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: SizedBox(
                          width: constraints.maxWidth,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              return ListTile(
                                title: Text(option),
                                trailing: Text(
                                  _quickTasks[option]!.name.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                                onTap: () {
                                  onSelected(option);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
            );
          },
        );
      },
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return BlocBuilder<TaskFormBloc, TaskFormState>(
      buildWhen: (p, c) => p.date != c.date || p.time != c.time,
      builder: (context, state) {
        final date = state.date;
        final time = state.time;
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Due Date'),
          subtitle: Text(
            DateFormat('EEE, MMM dd, yyyy - hh:mm a').format(dateTime),
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (pickedDate != null && context.mounted) {
              context.read<TaskFormBloc>().add(TaskDateChanged(pickedDate));
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: time,
              );
              if (pickedTime != null && context.mounted) {
                context.read<TaskFormBloc>().add(TaskTimeChanged(pickedTime));
              }
            }
          },
        );
      },
    );
  }

  Widget _buildImportanceSelector(BuildContext context) {
    return BlocBuilder<TaskFormBloc, TaskFormState>(
      buildWhen: (p, c) => p.importance != c.importance,
      builder: (context, state) {
        return SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: TaskImportance.values.map((imp) {
              final isSelected = state.importance == imp;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(imp.name.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<TaskFormBloc>().add(
                        TaskImportanceChanged(imp),
                      );
                    }
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    return BlocBuilder<TaskFormBloc, TaskFormState>(
      buildWhen: (p, c) => p.category != c.category,
      builder: (context, state) {
        return DropdownButtonFormField<TaskCategory>(
          value: state.category,
          items: TaskCategory.values.map((cat) {
            return DropdownMenuItem(
              value: cat,
              child: Text(cat.name.toUpperCase()),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              context.read<TaskFormBloc>().add(TaskCategoryChanged(val));
            }
          },
          decoration: const InputDecoration(border: OutlineInputBorder()),
        );
      },
    );
  }
}
