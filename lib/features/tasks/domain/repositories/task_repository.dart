import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks(String userId);
  Future<TaskEntity> addTask(TaskEntity task);
  Future<TaskEntity> updateTask(TaskEntity task);
  Future<void> deleteTask(String userId, String taskId);
}
