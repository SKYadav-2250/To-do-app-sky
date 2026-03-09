import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class AddEditTaskScreen extends StatefulWidget {
  final TaskEntity? task;
  final String userId;

  const AddEditTaskScreen({super.key, this.task, required this.userId});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(text: widget.task?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final isUpdating = widget.task != null;
      final newTask = TaskEntity(
        id: isUpdating ? widget.task!.id : '',
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        isCompleted: isUpdating ? widget.task!.isCompleted : false,
        createdAt: isUpdating ? widget.task!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
        userId: widget.userId,
      );

      if (isUpdating) {
        context.read<TaskBloc>().add(UpdateTaskEvent(task: newTask));
      } else {
        context.read<TaskBloc>().add(AddTaskEvent(task: newTask));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUpdating = widget.task != null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(isUpdating ? 'Edit Task' : 'Add Task'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GradientBackground(
        child: BlocConsumer<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is TaskOperationSuccess) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: GlassContainer(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          controller: _titleController,
                          hintText: 'Task Title',
                          prefixIcon: Icons.title,
                          validator: (val) => val != null && val.isEmpty ? 'Please enter a title' : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _descController,
                          hintText: 'Description',
                          prefixIcon: Icons.description_outlined,
                        ),
                        const SizedBox(height: 32),
                        CustomButton(
                          text: isUpdating ? 'UPDATE TASK' : 'SAVE TASK',
                          isLoading: state is TaskLoading, // Note: For a granular UI maybe we shouldn't block the whole screen with Loading but this is simple enough.
                          onPressed: _saveTask,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
