class PaymentModel {
  final int id;
  final int taskId;
  final int buyerId;
  final double amount;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  PaymentModel({
    required this.id,
    required this.taskId,
    required this.buyerId,
    required this.amount,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      taskId: json['task_id'],
      buyerId: json['buyer_id'],
      amount: (json['amount'] as num).toDouble(),
      isCompleted: json['is_completed'],
      createdAt: DateTime.parse(json['created_at']),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'buyer_id': buyerId,
      'amount': amount,
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
