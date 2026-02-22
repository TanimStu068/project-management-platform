import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task_forge/core/api_client.dart';
import '../core/secure_storage.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;
  final SecureStorage storage;

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  User? _user;
  User? get user => _user;

  AuthProvider({required this.authService, required this.storage});

  // ---------------- LOGIN ----------------
  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await authService.login(email, password);

      final token = data['access_token'];
      await storage.saveToken(token);

      // Decode JWT to get user info
      final payload = _parseJwt(token);
      final role = UserRole.values.byName(payload['role']);
      final id = int.parse(payload['sub']);

      _user = User(id: id, email: email, role: role);

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ---------------- REGISTER ----------------
  Future<bool> register(String email, String password, UserRole role) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // First register user
      await authService.register(email, password, role);

      // Then login
      return await login(email, password);
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ---------------- LOGOUT ----------------
  Future<void> logout() async {
    await storage.deleteToken();
    _user = null;
    notifyListeners();
  }

  // ---------------- JWT PARSER ----------------
  Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('Invalid token');

    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return json.decode(decoded);
  }

  // Get ApiClient with token
  Future<ApiClient> getApiClient() async {
    final token = await storage.readToken();
    return ApiClient(token: token);
  }
}
