// lib/modules/payment/models/payment.dart

class PaymentModel {
  final int paymentId;
  final int orderId;
  final String paymentStatus;
  final String transactionId;
  final double amount;
  final String method;
  final DateTime createdAt;

  PaymentModel({
    required this.paymentId,
    required this.orderId,
    required this.paymentStatus,
    required this.transactionId,
    required this.amount,
    required this.method,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentId: json['paymentId'] ?? 0,
      orderId: json['orderId'] ?? 0,
      paymentStatus: json['paymentStatus'] ?? '',
      transactionId: json['transactionId'] ?? '',
      amount: (json['amount'] as num? ?? 0).toDouble(),
      method: json['method'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
