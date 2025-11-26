class PaymentHistoryModel {
  final int paymentId;
  final int orderId;
  final String paymentStatus;
  final String transactionId;
  final double totalPrice; // Changed from amount to totalPrice
  final String? method; // This might still be missing
  final DateTime createdAt;

  PaymentHistoryModel({
    required this.paymentId,
    required this.orderId,
    required this.paymentStatus,
    required this.transactionId,
    required this.totalPrice, // Changed from amount to totalPrice
    this.method,
    required this.createdAt,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    print("🔄 PaymentHistoryModel.fromJson() - Parsing JSON: $json");

    try {
      // Handle createdAt - it can be null in your API
      DateTime parsedDate;
      try {
        final createdAtString = json['createdAt']?.toString();
        if (createdAtString != null && createdAtString.isNotEmpty) {
          parsedDate = DateTime.parse(createdAtString);
        } else {
          print("ℹ️ createdAt is null or empty, using current date");
          parsedDate = DateTime.now();
        }
      } catch (e) {
        print("❌ Date parsing failed, using current date. Error: $e");
        parsedDate = DateTime.now();
      }

      final payment = PaymentHistoryModel(
        paymentId: _parseInt(json['paymentId']),
        orderId: _parseInt(json['orderId']),
        paymentStatus: _parseString(json['paymentStatus']),
        transactionId: _parseString(json['transactionId']),
        totalPrice: _parseDouble(json['totalPrice']), // Changed from amount to totalPrice
        method: _parseString(json['method']), // This might be null
        createdAt: parsedDate,
      );

      print("✅ PaymentHistoryModel.fromJson() - Successfully parsed: Payment ID ${payment.paymentId}, Total Price: ${payment.totalPrice}");
      return payment;
    } catch (e) {
      print("❌ PaymentHistoryModel.fromJson() - Error: $e");
      print("📋 JSON that caused error: $json");
      rethrow;
    }
  }

  // Helper methods for safe parsing
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'orderId': orderId,
      'paymentStatus': paymentStatus,
      'transactionId': transactionId,
      'totalPrice': totalPrice, // Changed from amount to totalPrice
      'method': method,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Copy with method for updates
  PaymentHistoryModel copyWith({
    int? paymentId,
    int? orderId,
    String? paymentStatus,
    String? transactionId,
    double? totalPrice, // Changed from amount to totalPrice
    String? method,
    DateTime? createdAt,
  }) {
    return PaymentHistoryModel(
      paymentId: paymentId ?? this.paymentId,
      orderId: orderId ?? this.orderId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      transactionId: transactionId ?? this.transactionId,
      totalPrice: totalPrice ?? this.totalPrice, // Changed from amount to totalPrice
      method: method ?? this.method,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Getter for backward compatibility if needed
  double get amount => totalPrice;
}