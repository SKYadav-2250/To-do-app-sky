import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/login_screen.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import 'add_edit_task_screen.dart';
import '../../../../injection_container.dart' as di;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<TaskBloc>().add(FetchTasksEvent(userId: authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('My Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutUserEvent());
              },
            ),
          ],
        ),
        body: GradientBackground(
          child: SafeArea(
            child: BlocConsumer<TaskBloc, TaskState>(
              listener: (context, state) {
                if (state is TaskOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is TaskError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.white))),
                  );
                }
              },
              buildWhen: (previous, current) => current is! TaskOperationSuccess && current is! TaskError,
              builder: (context, state) {
                if (state is TaskLoading || state is TaskInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TasksLoaded) {
                  if (state.tasks.isEmpty) {
                    return const Center(
                      child: Text('No tasks found. Add a new task!', style: TextStyle(fontSize: 16)),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async => _fetchTasks(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.tasks.length,
                      itemBuilder: (context, index) {
                        final task = state.tasks[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GlassContainer(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: task.isCompleted,
                                  shape: const CircleBorder(),
                                  onChanged: (_) {
                                    context.read<TaskBloc>().add(ToggleTaskCompletionEvent(task: task));
                                  },
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (task.description.isNotEmpty)
                                        Text(
                                          task.description,
                                          style: TextStyle(
                                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                                  onPressed: () {
                                    final authState = context.read<AuthBloc>().state;
                                    if (authState is Authenticated) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value: context.read<TaskBloc>(),
                                            child: AddEditTaskScreen(task: task, userId: authState.user.id),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () {
                                    final authState = context.read<AuthBloc>().state;
                                    if (authState is Authenticated) {
                                      context.read<TaskBloc>().add(
                                        DeleteTaskEvent(userId: authState.user.id, taskId: task.id),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center(child: Text('Something went wrong'));
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            final authState = context.read<AuthBloc>().state;
            if (authState is Authenticated) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<TaskBloc>(),
                    child: AddEditTaskScreen(userId: authState.user.id),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
