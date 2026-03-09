import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TaskEntity>> getTasks(String userId) async {
    return await remoteDataSource.getTasks(userId);
  }

  @override
  Future<TaskEntity> addTask(TaskEntity task) async {
    final taskModel = TaskModel.fromEntity(task);
    return await remoteDataSource.addTask(taskModel);
  }

  @override
  Future<TaskEntity> updateTask(TaskEntity task) async {
    final taskModel = TaskModel.fromEntity(task);
    return await remoteDataSource.updateTask(taskModel);
  }

  @override
  Future<void> deleteTask(String userId, String taskId) async {
    return await remoteDataSource.deleteTask(userId, taskId);
  }
}
