import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_forge/models/user_model.dart';
import 'package:task_forge/providers/project_provider.dart';
import 'package:task_forge/screens/admin/admin_dashboard_screen.dart';
import 'package:task_forge/screens/buyer/buyer_dashboard_screen.dart';
import 'package:task_forge/screens/developer/developer_dashboard_screen.dart';
import 'package:task_forge/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Color(0xFF1F1F1F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or App Name
                Icon(Icons.task_alt, size: 80, color: Color(0xFF4CAF50)),
                const SizedBox(height: 20),
                const Text(
                  'TaskForge',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 40),

                // Email & Password
                CustomTextField(controller: emailController, hintText: 'Email'),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 30),

                // Login Button
                auth.loading
                    ? const CircularProgressIndicator(color: Color(0xFF4CAF50))
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            final success = await context
                                .read<AuthProvider>()
                                .login(
                                  emailController.text,
                                  passwordController.text,
                                );

                            if (!mounted) return;

                            final auth = context.read<AuthProvider>();
                            final projectProvider = context
                                .read<ProjectProvider>();

                            if (success) {
                              await projectProvider.fetchProjects();
                              if (auth.user!.role == UserRole.buyer) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BuyerDashboardScreen(),
                                  ),
                                );
                              } else if (auth.user!.role ==
                                  UserRole.developer) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DeveloperDashboardScreen(),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AdminDashboardScreen(),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(auth.error ?? 'Login failed'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ),
                const SizedBox(height: 20),

                // Register Button
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text("Don't have an account? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
