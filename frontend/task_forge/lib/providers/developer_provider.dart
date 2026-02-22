import 'package:flutter/material.dart';
import '../services/developer_service.dart';
import '../providers/auth_provider.dart';

class DeveloperProvider extends ChangeNotifier {
  final DeveloperService developerService;
  final AuthProvider authProvider;

  DeveloperProvider({
    required this.developerService,
    required this.authProvider,
  });

  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _developers = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get developers => _developers;

  Future<void> fetchDevelopers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiClient = await authProvider.getApiClient(); // token included
      final service = DeveloperService(apiClient);
      final devs = await service.fetchDevelopers();
      print("Fetched developers: $devs"); // debug
      _developers = devs;
    } catch (e) {
      _error = e.toString();
      print("Developer fetch error: $_error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
