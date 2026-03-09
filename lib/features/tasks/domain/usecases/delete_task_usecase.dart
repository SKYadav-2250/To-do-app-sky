import '../repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> call(String userId, String taskId) {
    return repository.deleteTask(userId, taskId);
  }
}
