import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_forge/providers/auth_provider.dart';
import 'package:task_forge/screens/developer/submit_task_screen.dart';
import 'package:task_forge/services/task_service.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import 'payment_screen.dart';
import '../../models/user_model.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userRole = authProvider.user?.role;
    final taskProvider = context.watch<TaskProvider>();

    final totalAmount = (task.hoursSpent ?? 0) * task.hourlyRate;

    if (userRole == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF4CAF50),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Status: ${task.status.name}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Hourly Rate: \$${task.hourlyRate}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // DEVELOPER VIEW
                      if (userRole == UserRole.developer) ...[
                        if (task.status == TaskStatus.TODO)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: taskProvider.isLoading
                                ? null
                                : () => taskProvider.startTask(task.id),
                            child: const Text("Start Task"),
                          ),
                        if (task.status == TaskStatus.IN_PROGRESS)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SubmitTaskScreen(task: task),
                                ),
                              );
                            },
                            child: const Text("Submit Task"),
                          ),
                        if (task.status == TaskStatus.SUBMITTED)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              "Waiting for buyer payment...",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (task.status == TaskStatus.PAID)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              "Task Paid ✔",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],

                      // BUYER VIEW
                      if (userRole == UserRole.buyer) ...[
                        if (task.status == TaskStatus.TODO)
                          const Text(
                            "Assign developer from project screen.",
                            style: TextStyle(color: Colors.white70),
                          ),
                        if (task.status == TaskStatus.IN_PROGRESS)
                          const Text(
                            "Task is currently in progress.",
                            style: TextStyle(color: Colors.white70),
                          ),
                        if (task.status == TaskStatus.SUBMITTED) ...[
                          Text(
                            "Hours Spent: ${task.hoursSpent}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "Total Amount Due: \$${totalAmount.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Pay Now"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PaymentScreen(task: task),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Download locked until payment.",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        if (task.status == TaskStatus.PAID) ...[
                          const Text(
                            "Payment Completed ✔",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              try {
                                final apiClient = await authProvider
                                    .getApiClient();
                                final serviceWithToken = TaskService(apiClient);

                                final response = await serviceWithToken
                                    .downloadTaskSolution(task.id);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Downloaded ${response.bodyBytes.length} bytes ✔",
                                    ),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Download failed: $e"),
                                  ),
                                );
                              }
                            },
                            child: const Text("Download Solution"),
                          ),
                        ],
                      ],

                      // ADMIN VIEW
                      if (userRole == UserRole.admin) ...[
                        const Divider(color: Colors.white54),
                        const Text(
                          "Admin View",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Developer ID: ${task.developerId ?? "Not assigned"}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          "Hours Spent: ${task.hoursSpent ?? "-"}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          "Paid At: ${task.paidAt ?? "-"}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          "Submission Locked: ${task.submissionLocked}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
