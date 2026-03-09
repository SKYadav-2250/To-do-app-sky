import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TasksLoaded extends TaskState {
  final List<TaskEntity> tasks;

  const TasksLoaded({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

class TaskOperationSuccess extends TaskState {
  final String message;
  const TaskOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class TaskError extends TaskState {
  final String message;

  const TaskError({required this.message});

  @override
  List<Object> get props => [message];
}
