import '../core/api_client.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService(this.apiClient);

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    UserRole role,
  ) async {
    final data = await apiClient.post(
      '/auth/register',
      body: {'email': email, 'password': password, 'role': role.name},
    );

    return data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = await apiClient.post(
      '/auth/login',
      body: {'email': email, 'password': password},
    );

    return data;
  }
}
