import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class AddTaskUseCase {
  final TaskRepository repository;

  AddTaskUseCase(this.repository);

  Future<TaskEntity> call(TaskEntity task) {
    return repository.addTask(task);
  }
}
