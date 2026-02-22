import 'package:task_forge/core/api_client.dart';
import 'package:task_forge/models/project_model.dart';

class ProjectService {
  final ApiClient defaultApiClient;

  ProjectService(this.defaultApiClient);

  // CREATE PROJECT
  Future<ProjectModel> createProject(
    ProjectModel project, {
    ApiClient? apiClient,
  }) async {
    final client = apiClient ?? defaultApiClient;
    final data = await client.post(
      '/projects/',
      body: {'title': project.title, 'description': project.description},
    );
    return ProjectModel.fromJson(data);
  }

  // GET ALL PROJECTS (Buyer)
  Future<List<ProjectModel>> fetchBuyerProjects({ApiClient? apiClient}) async {
    final client = apiClient ?? defaultApiClient;
    final data = await client.get('/projects/');
    return (data as List).map((json) => ProjectModel.fromJson(json)).toList();
  }

  // GET SINGLE PROJECT
  Future<ProjectModel> fetchProject(
    int projectId, {
    ApiClient? apiClient,
  }) async {
    final client = apiClient ?? defaultApiClient;
    final data = await client.get('/projects/$projectId');
    return ProjectModel.fromJson(data);
  }
}
