import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class FetchTasksEvent extends TaskEvent {
  final String userId;
  const FetchTasksEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class AddTaskEvent extends TaskEvent {
  final TaskEntity task;
  const AddTaskEvent({required this.task});

  @override
  List<Object> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;
  const UpdateTaskEvent({required this.task});

  @override
  List<Object> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String userId;
  final String taskId;
  const DeleteTaskEvent({required this.userId, required this.taskId});

  @override
  List<Object> get props => [userId, taskId];
}

class ToggleTaskCompletionEvent extends TaskEvent {
  final TaskEntity task;
  const ToggleTaskCompletionEvent({required this.task});

  @override
  List<Object> get props => [task];
}
