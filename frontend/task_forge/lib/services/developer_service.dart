import 'package:task_forge/core/api_client.dart';

class DeveloperService {
  final ApiClient apiClient;

  DeveloperService(this.apiClient);

  Future<List<Map<String, dynamic>>> fetchDevelopers() async {
    final data = await apiClient.get('/developers/'); // data is List<dynamic>

    return (data as List<dynamic>)
        .map((d) => {'id': d['id'], 'email': d['email'] as String})
        .toList();
  }
}
