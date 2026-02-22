import 'package:task_forge/core/api_client.dart';
import 'package:task_forge/models/task_model.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';

class TaskService {
  final ApiClient apiClient;

  TaskService(this.apiClient);

  // BUYER METHODS
  Future<List<TaskModel>> fetchProjectTasks(
    int projectId, {
    ApiClient? apiClient,
  }) async {
    final client = apiClient ?? this.apiClient;
    final data = await client.get('/projects/$projectId');
    final List<dynamic> taskList = data['tasks'] as List<dynamic>? ?? [];
    return taskList.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<TaskModel> createTask(
    int projectId,
    TaskModel task, {
    ApiClient? apiClient, // <-- add optional parameter
  }) async {
    final client =
        apiClient ?? this.apiClient; // use the passed client if available

    final data = await client.post(
      '/tasks/$projectId',
      body: {
        'title': task.title,
        'description': task.description,
        'developer_id': task.developerId,
        'hourly_rate': task.hourlyRate,
      },
    );

    return TaskModel.fromJson(data);
  }

  // DEVELOPER METHODS

  Future<List<TaskModel>> fetchDeveloperTasks({ApiClient? apiClient}) async {
    final client = apiClient ?? this.apiClient;
    final data = await client.get('/tasks/developer');
    return (data as List).map((json) => TaskModel.fromJson(json)).toList();
  }

  /// Developer starts task (status = IN_PROGRESS)
  Future<TaskModel> startTask(int taskId) async {
    final data = await apiClient.post('/tasks/start/$taskId', body: {});
    return TaskModel.fromJson(data);
  }

  Future<TaskModel> submitTask(
    int taskId,
    double hoursSpent,
    File zipFile,
  ) async {
    final uri = Uri.parse('${apiClient.baseUrl}/tasks/submit/$taskId');
    final request = http.MultipartRequest('POST', uri);

    request.fields['hours_spent'] = hoursSpent.toString();
    request.files.add(
      await http.MultipartFile.fromPath(
        'zip_file',
        zipFile.path,
        filename: basename(zipFile.path),
      ),
    );

    // Add auth token from ApiClient
    if (apiClient.token != null) {
      request.headers['Authorization'] = 'Bearer ${apiClient.token}';
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('Failed to submit task: ${response.body}');
    }

    return TaskModel.fromJson(jsonDecode(response.body));
  }

  /// Download solution URL
  Future<http.Response> downloadTaskSolution(int taskId) async {
    final response = await http.get(
      Uri.parse('${apiClient.baseUrl}/tasks/download/$taskId'),
      headers: {'Authorization': 'Bearer ${apiClient.token}'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to download file: ${response.body}');
    }

    return response;
  }

  /// Buyer assigns task to a developer
  Future<TaskModel> assignTask(int taskId, int developerId) async {
    final data = await apiClient.put(
      '/tasks/$taskId/assign',
      body: {'developer_id': developerId},
    );

    return TaskModel.fromJson(data);
  }
}
