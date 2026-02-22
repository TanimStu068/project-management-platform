import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_forge/providers/admin_provider.dart';
import 'package:task_forge/providers/auth_provider.dart';
import 'package:task_forge/screens/login_screen.dart';
import 'package:task_forge/widgets/build_stat_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    final adminProvider = context.read<AdminProvider>();
    adminProvider.fetchStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dark premium gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Color(0xFF1F1F1F)],
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
                color: const Color(0xFF1E1E1E),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Admin Dashboard",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Color(0xFF4CAF50)),
                      tooltip: "Logout",
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
                child: Consumer<AdminProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4CAF50),
                        ),
                      );
                    }

                    if (provider.error != null) {
                      return Center(
                        child: Text(
                          "Error: ${provider.error}",
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      );
                    }

                    final stats = provider.stats;
                    if (stats == null) {
                      return const Center(
                        child: Text(
                          "No data available",
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: const Color(0xFF4CAF50),
                      onRefresh: () => provider.fetchStats(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // -------------------- Stats Grid --------------------
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2 -
                                      24,
                                  child: StatCard(
                                    title: "Total Projects",
                                    value: stats.totalProjects,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2 -
                                      24,
                                  child: StatCard(
                                    title: "Total Tasks",
                                    value: stats.totalTasks,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2 -
                                      24,
                                  child: StatCard(
                                    title: "Completed Tasks",
                                    value: stats.completedTasks,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2 -
                                      24,
                                  child: StatCard(
                                    title: "Total Payments",
                                    value: stats.totalPayments,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2 -
                                      24,
                                  child: StatCard(
                                    title: "Pending Payments",
                                    value: stats.pendingPayments,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2 -
                                      24,
                                  child: StatCard(
                                    title: "Total Buyers",
                                    value: stats.totalBuyers,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2 -
                                      24,
                                  child: StatCard(
                                    title: "Total Developers",
                                    value: stats.totalDevelopers,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2 -
                                      24,
                                  child: StatCard(
                                    title: "Total Developer Hours",
                                    value: stats.totalHoursLogged
                                        .toStringAsFixed(2),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2 -
                                      24,
                                  child: StatCard(
                                    title: "Revenue",
                                    value:
                                        "\$${stats.revenue.toStringAsFixed(2)}",
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // -------------------- Tasks by Status --------------------
                            const Text(
                              "Tasks by Status",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                            const Divider(color: Colors.white24),
                            ...stats.tasksByStatus.entries.map(
                              (e) => Card(
                                color: const Color(0xFF1E1E1E),
                                shadowColor: Colors.black45,
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(
                                    e.key,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: Text(
                                    e.value.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4CAF50),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
