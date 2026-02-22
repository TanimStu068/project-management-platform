import 'package:flutter/material.dart';
import 'package:task_forge/providers/auth_provider.dart';
import '../models/project_model.dart';
import '../services/project_service.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectService projectService;
  final AuthProvider authProvider;

  ProjectProvider({required this.projectService, required this.authProvider});

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<ProjectModel> _projects = [];
  List<ProjectModel> get projects => _projects;

  // FETCH BUYER PROJECTS
  Future<void> fetchProjects() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiClient = await authProvider.getApiClient();
      _projects = await projectService.fetchBuyerProjects(apiClient: apiClient);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE PROJECT
  Future<ProjectModel?> createProject(ProjectModel project) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiClient = await authProvider.getApiClient();
      final newProject = await projectService.createProject(
        project,
        apiClient: apiClient,
      );
      _projects.add(newProject);
      return newProject;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // FETCH SINGLE PROJECT
  Future<ProjectModel?> fetchProject(int projectId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiClient = await authProvider.getApiClient();
      final project = await projectService.fetchProject(
        projectId,
        apiClient: apiClient,
      );
      final index = _projects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        _projects[index] = project;
      } else {
        _projects.add(project);
      }
      return project;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
