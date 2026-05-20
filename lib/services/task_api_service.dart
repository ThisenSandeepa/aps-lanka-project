import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/task_model.dart';
import 'api_exception.dart';

class TaskApiService {
  TaskApiService({http.Client? client}) : _client = client ?? http.Client();

  static const _tasksUrl = 'https://jsonplaceholder.typicode.com/todos';
  final http.Client _client;

  Future<List<TaskModel>> fetchTasks() async {
    try {
      final response = await _client
          .get(Uri.parse(_tasksUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map((item) => TaskModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      throw const ApiException('Unable to load tasks. Please try again.');
    } catch (error) {
      if (error is ApiException) rethrow;
      throw const ApiException(
        'Network error while loading tasks. Pull to refresh and try again.',
      );
    }
  }

  Future<TaskModel> addTask(TaskModel task) async {
    return _sendTaskMutation(
      method: 'POST',
      uri: Uri.parse(_tasksUrl),
      task: task,
      expectedStatusCodes: {200, 201},
    );
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    return _sendTaskMutation(
      method: 'PUT',
      uri: Uri.parse('$_tasksUrl/${task.id}'),
      task: task,
      expectedStatusCodes: {200},
    );
  }

  Future<void> deleteTask(int id) async {
    try {
      final response = await _client
          .delete(Uri.parse('$_tasksUrl/$id'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw const ApiException('Unable to delete task. Please try again.');
      }
    } catch (error) {
      if (error is ApiException) rethrow;
      throw const ApiException('Network error while deleting task.');
    }
  }

  Future<TaskModel> _sendTaskMutation({
    required String method,
    required Uri uri,
    required TaskModel task,
    required Set<int> expectedStatusCodes,
  }) async {
    try {
      final request = http.Request(method, uri)
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'title': task.title,
          'completed': task.completed,
        });

      final streamedResponse = await _client
          .send(request)
          .timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(streamedResponse);

      if (expectedStatusCodes.contains(response.statusCode)) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return TaskModel.fromJson(data, isLocal: task.isLocal)
            .copyWith(id: task.id);
      }

      throw const ApiException('Unable to save task. Please try again.');
    } catch (error) {
      if (error is ApiException) rethrow;
      throw const ApiException('Network error while saving task.');
    }
  }
}
