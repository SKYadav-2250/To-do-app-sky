import '../../../../core/network/api_client.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks(String userId);
  Future<TaskModel> addTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String userId, String taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final ApiClient apiClient;

  TaskRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TaskModel>> getTasks(String userId) async {
    try {
      final response = await apiClient.get('tasks/$userId.json');
      if (response.data != null && response.data is Map) {
        final Map<String, dynamic> data = response.data;
        return data.entries.map((e) => TaskModel.fromJson(e.value, e.key)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    try {
      // Create a unique ID or let Firebase do it. 
      // POST to /tasks/{userId}.json generates a unique key.
      final response = await apiClient.post('tasks/${task.userId}.json', data: task.toJson());
      if (response.data != null && response.data['name'] != null) {
        return TaskModel(
          id: response.data['name'], // Firebase generated ID
          title: task.title,
          description: task.description,
          isCompleted: task.isCompleted,
          createdAt: task.createdAt,
          updatedAt: task.updatedAt,
          userId: task.userId,
        );
      }
      throw Exception('Failed to add task: Invalid response');
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      await apiClient.patch('tasks/${task.userId}/${task.id}.json', data: task.toJson());
      return task;
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String userId, String taskId) async {
    try {
      await apiClient.delete('tasks/$userId/$taskId.json');
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
}
