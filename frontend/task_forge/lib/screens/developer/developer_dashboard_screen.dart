import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_forge/providers/auth_provider.dart';
import 'package:task_forge/providers/task_provider.dart';
import 'package:task_forge/screens/buyer/task_detail_screen.dart';
import 'package:task_forge/screens/login_screen.dart';
import 'package:task_forge/widgets/task_card.dart';

class DeveloperDashboardScreen extends StatefulWidget {
  const DeveloperDashboardScreen({super.key});

  @override
  State<DeveloperDashboardScreen> createState() =>
      _DeveloperDashboardScreenState();
}

class _DeveloperDashboardScreenState extends State<DeveloperDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch developer tasks
    Future.microtask(() => context.read<TaskProvider>().fetchDeveloperTasks());
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      // Dark premium gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                color: const Color(0xFF1C1C1C),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Developer Dashboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Color(0xFF4CAF50)),
                      tooltip: 'Logout',
                      onPressed: () {
                        final authProvider = context.read<AuthProvider>();
                        authProvider.logout();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Body
              Expanded(
                child: taskProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4CAF50),
                        ),
                      )
                    : taskProvider.developerTasks.isEmpty
                    ? const Center(
                        child: Text(
                          'No tasks assigned.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: taskProvider.developerTasks.length,
                        itemBuilder: (context, index) {
                          final task = taskProvider.developerTasks[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TaskDetailScreen(task: task),
                                ),
                              );
                            },
                            child: Card(
                              color: const Color(0xFF1E1E1E),
                              shadowColor: Colors.black45,
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TaskCard(task: task),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
