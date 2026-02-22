import 'package:flutter/material.dart';
import 'package:task_forge/providers/auth_provider.dart';

class AdminStats {
  final int totalProjects;
  final int totalTasks;
  final Map<String, int> tasksByStatus;
  final int completedTasks;
  final int totalPayments;
  final int pendingPayments;
  final int totalBuyers;
  final int totalDevelopers;
  final double totalHoursLogged;
  final double revenue;

  AdminStats({
    required this.totalProjects,
    required this.totalTasks,
    required this.tasksByStatus,
    required this.completedTasks,
    required this.totalPayments,
    required this.pendingPayments,
    required this.totalBuyers,
    required this.totalDevelopers,
    required this.totalHoursLogged,
    required this.revenue,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      totalProjects: json['total_projects'],
      totalTasks: json['total_tasks'],
      tasksByStatus: Map<String, int>.from(json['tasks_by_status']),
      completedTasks: json['completed_tasks'],
      totalPayments: json['total_payments'],
      pendingPayments: json['pending_payments'],
      totalBuyers: json['total_buyers'],
      totalDevelopers: json['total_developers'],
      totalHoursLogged: (json['total_hours_logged'] as num).toDouble(),
      revenue: (json['revenue'] as num).toDouble(),
    );
  }
}

class AdminProvider extends ChangeNotifier {
  final AuthProvider authProvider;

  AdminProvider({required this.authProvider});
  bool _isLoading = false;
  String? _error;
  AdminStats? _stats;

  bool get isLoading => _isLoading;
  String? get error => _error;
  AdminStats? get stats => _stats;

  Future<void> fetchStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiClient = await authProvider.getApiClient();
      final data = await apiClient.get('/admin/stats');
      _stats = AdminStats.fromJson(data);
    } catch (e) {
      _error = e.toString();
      _stats = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
