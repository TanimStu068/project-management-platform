import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:task_forge/providers/admin_provider.dart';
import 'package:task_forge/providers/payment_provider.dart';

import '../core/api_client.dart';
import '../core/secure_storage.dart';

import '../services/auth_service.dart';
import '../services/project_service.dart';
import '../services/task_service.dart';
import '../services/payment_service.dart';

import '../providers/auth_provider.dart';
import '../providers/project_provider.dart';
import '../providers/task_provider.dart';
import '../services/developer_service.dart';
import '../providers/developer_provider.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    // ---------------- CORE ----------------
    Provider<ApiClient>(create: (_) => ApiClient()),
    Provider<SecureStorage>(create: (_) => SecureStorage()),

    // ---------------- SERVICES ----------------
    Provider<AuthService>(
      create: (context) => AuthService(context.read<ApiClient>()),
    ),
    Provider<ProjectService>(
      create: (context) => ProjectService(context.read<ApiClient>()),
    ),
    Provider<TaskService>(
      create: (context) => TaskService(context.read<ApiClient>()),
    ),
    Provider<DeveloperService>(
      create: (context) => DeveloperService(context.read<ApiClient>()),
    ),
    Provider<PaymentService>(
      create: (context) => PaymentService(context.read<ApiClient>()),
    ),

    // ---------------- PROVIDERS ----------------
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(
        authService: context.read<AuthService>(),
        storage: context.read<SecureStorage>(),
      ),
    ),
    ChangeNotifierProvider<ProjectProvider>(
      create: (context) => ProjectProvider(
        projectService: context.read<ProjectService>(),
        authProvider: context.read<AuthProvider>(),
      ),
    ),
    ChangeNotifierProvider<TaskProvider>(
      create: (context) => TaskProvider(
        taskService: context.read<TaskService>(),
        authProvider: context.read<AuthProvider>(),
      ),
    ),
    ChangeNotifierProvider<DeveloperProvider>(
      create: (context) => DeveloperProvider(
        developerService: context.read<DeveloperService>(), // tokenless
        authProvider: context.read<AuthProvider>(),
      ),
    ),
    ChangeNotifierProvider<PaymentProvider>(
      create: (context) => PaymentProvider(
        paymentService: context.read<PaymentService>(),
        authProvider: context.read<AuthProvider>(), // inject authProvider
      ),
    ),
    ChangeNotifierProvider<AdminProvider>(
      create: (context) =>
          AdminProvider(authProvider: context.read<AuthProvider>()),
    ),
  ];
}
