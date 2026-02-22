import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_forge/core/constants.dart';

class ApiClient {
  final String baseUrl;
  final String? token;

  ApiClient({String? baseUrl, this.token})
    : baseUrl = baseUrl ?? AppConstants.baseUrl;
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw Exception(data['detail'] ?? 'Error ${response.statusCode}');
    }
    return data;
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw Exception(data['detail'] ?? 'Error ${response.statusCode}');
    }
    return data;
  }

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(url, headers: headers);
    final data = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw Exception(data['detail'] ?? 'Error ${response.statusCode}');
    }
    return data;
  }
}
