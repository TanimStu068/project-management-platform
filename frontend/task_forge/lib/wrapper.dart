import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_forge/providers/auth_provider.dart';
import 'package:task_forge/screens/admin/admin_dashboard_screen.dart';
import 'package:task_forge/screens/buyer/buyer_dashboard_screen.dart';
import 'package:task_forge/screens/developer/developer_dashboard_screen.dart';
import 'package:task_forge/screens/login_screen.dart';
import '../models/user_model.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    // If still loading, show splash
    if (authProvider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Not logged in
    if (user == null) {
      return const LoginScreen();
    }

    // Logged in -> check role
    switch (user.role) {
      case UserRole.admin:
        return const AdminDashboardScreen();
      case UserRole.buyer:
        return const BuyerDashboardScreen();
      case UserRole.developer:
        return const DeveloperDashboardScreen();
    }
  }
}
