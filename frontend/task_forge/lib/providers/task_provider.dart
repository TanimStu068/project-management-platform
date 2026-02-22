import 'package:flutter/material.dart';
import 'package:task_forge/models/payment_model.dart';
import 'package:task_forge/providers/auth_provider.dart';
import 'package:task_forge/services/payment_service.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import 'dart:io';

class TaskProvider extends ChangeNotifier {
  final TaskService taskService;
  final AuthProvider authProvider;

  TaskProvider({required this.taskService, required this.authProvider});

  Map<int, List<TaskModel>> _projectTasks = {};
  List<TaskModel> _developerTasks = [];
  bool _isLoading = false;
  String? _error;

  Map<int, List<TaskModel>> get projectTasks => _projectTasks;
  List<TaskModel> get developerTasks => _developerTasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ---------------- BUYER METHODS ----------------
  Future<void> fetchProjectTasks(int projectId) async {
    final apiClient = await authProvider.getApiClient();
    final tasks = await taskService.fetchProjectTasks(
      projectId,
      apiClient: apiClient,
    );
    _projectTasks[projectId] = tasks;
    notifyListeners();
  }

  Future<TaskModel?> createTask(int projectId, TaskModel task) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final apiClient = await authProvider.getApiClient();
      final newTask = await taskService.createTask(
        projectId,
        task,
        apiClient: apiClient,
      );
      _projectTasks.putIfAbsent(projectId, () => []);
      _projectTasks[projectId]!.add(newTask);
      return newTask;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- DEVELOPER METHODS ----------------

  Future<void> fetchDeveloperTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final apiClient = await authProvider.getApiClient();
      _developerTasks = await taskService.fetchDeveloperTasks(
        apiClient: apiClient,
      );
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<TaskModel?> startTask(int taskId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      // Get the token-enabled ApiClient
      final apiClient = await authProvider.getApiClient();
      // Create a TaskService using the token
      final serviceWithToken = TaskService(apiClient);

      final updatedTask = await serviceWithToken.startTask(taskId);
      updateLocalTask(updatedTask);
      return updatedTask;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<TaskModel?> submitTask(
    int taskId,
    double hoursSpent,
    File zipFile,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final apiClient = await authProvider.getApiClient();
      final serviceWithToken = TaskService(apiClient);

      final updatedTask = await serviceWithToken.submitTask(
        taskId,
        hoursSpent,
        zipFile,
      );
      updateLocalTask(updatedTask);
      return updatedTask;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PaymentModel?> payForTask(TaskModel task) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final apiClient = await authProvider.getApiClient();
      final paymentService = PaymentService(apiClient);

      final payment = await paymentService.payForTask(task.id);
      final updatedTask = task.copyWith(
        status: TaskStatus.PAID,
        submissionLocked: false,
      );
      updateLocalTask(updatedTask);
      return payment;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- HELPER ----------------
  void updateLocalTask(TaskModel updatedTask) {
    // Developer tasks
    final devIndex = _developerTasks.indexWhere((t) => t.id == updatedTask.id);
    if (devIndex != -1) _developerTasks[devIndex] = updatedTask;

    // Project tasks
    _projectTasks.forEach((projectId, tasks) {
      final idx = tasks.indexWhere((t) => t.id == updatedTask.id);
      if (idx != -1) tasks[idx] = updatedTask;
    });
  }

  Future<TaskModel?> assignTask(int taskId, int developerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedTask = await taskService.assignTask(taskId, developerId);

      updateLocalTask(updatedTask);
      return updatedTask;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> downloadTask(int taskId) async {
    final apiClient = await authProvider.getApiClient();
    final serviceWithToken = TaskService(apiClient);

    final response = await serviceWithToken.downloadTaskSolution(taskId);

    print("Downloaded bytes: ${response.bodyBytes.length}");
  }
}
