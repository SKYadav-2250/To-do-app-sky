import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_event.dart';
import 'task_state.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  TaskBloc({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(TaskInitial()) {
    on<FetchTasksEvent>(_onFetchTasksEvent);
    on<AddTaskEvent>(_onAddTaskEvent);
    on<UpdateTaskEvent>(_onUpdateTaskEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletionEvent);
  }

  Future<void> _onFetchTasksEvent(FetchTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasksUseCase(event.userId);
      emit(TasksLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> _onAddTaskEvent(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await addTaskUseCase(event.task);
      emit(const TaskOperationSuccess(message: 'Task added successfully'));
      add(FetchTasksEvent(userId: event.task.userId));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> _onUpdateTaskEvent(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await updateTaskUseCase(event.task);
      emit(const TaskOperationSuccess(message: 'Task updated successfully'));
      add(FetchTasksEvent(userId: event.task.userId));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> _onDeleteTaskEvent(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await deleteTaskUseCase(event.userId, event.taskId);
      emit(const TaskOperationSuccess(message: 'Task deleted successfully'));
      add(FetchTasksEvent(userId: event.userId));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> _onToggleTaskCompletionEvent(ToggleTaskCompletionEvent event, Emitter<TaskState> emit) async {
    try {
      final updatedTask = event.task.copyWith(isCompleted: !event.task.isCompleted);
      await updateTaskUseCase(updatedTask);
      add(FetchTasksEvent(userId: event.task.userId));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }
}
