import 'package:flutter/material.dart';
import 'package:task_forge/models/payment_model.dart';
import 'package:task_forge/models/task_model.dart';
import 'package:task_forge/providers/auth_provider.dart';
import '../services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService paymentService;
  final AuthProvider authProvider;

  PaymentProvider({required this.paymentService, required this.authProvider});

  bool _isLoading = false;
  String? _error;

  List<PaymentModel> _payments = []; // ← Add this
  List<PaymentModel> get payments => _payments;

  bool get isLoading => _isLoading;
  String? get error => _error;

  // PAY FOR TASK
  Future<PaymentModel?> payForTask(
    TaskModel task,
    Function(TaskModel) updateTask,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiClient = await authProvider.getApiClient();
      final serviceWithToken = PaymentService(apiClient);

      final payment = await serviceWithToken.payForTask(task.id);

      final updatedTask = task.copyWith(
        status: TaskStatus.PAID,
        submissionLocked: false,
      );
      updateTask(updatedTask);

      return payment;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // FETCH ALL PAYMENTS (Admin)
  Future<void> fetchPayments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _payments = await paymentService.fetchPayments();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
