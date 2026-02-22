import 'package:task_forge/core/api_client.dart';
import 'package:task_forge/models/payment_model.dart';

class PaymentService {
  final ApiClient apiClient;

  PaymentService(this.apiClient);

  /// Pay for a task (Buyer)
  Future<PaymentModel> payForTask(int taskId) async {
    final data = await apiClient.post('/payments/task/$taskId', body: {});
    return PaymentModel.fromJson(data);
  }

  /// Fetch all payments (optional, for admin dashboard)
  Future<List<PaymentModel>> fetchPayments() async {
    final data = await apiClient.get('/payments');
    return (data as List).map((json) => PaymentModel.fromJson(json)).toList();
  }
}
