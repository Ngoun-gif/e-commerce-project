import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/payment_history/models/payment_history_model.dart';

import '../services/payment_history_service.dart';

class PaymentHistoryProvider extends ChangeNotifier {
  List<PaymentHistoryModel> _payments = [];
  bool _loading = false;
  String? _error;

  // Getters
  List<PaymentHistoryModel> get payments => _payments;
  bool get loading => _loading;
  String? get error => _error;

  // ==================== FETCH ALL PAYMENTS ====================
  Future<void> fetchAllPayments() async {
    try {
      print("🔄 PaymentHistoryProvider.fetchAllPayments() started");
      _loading = true;
      _error = null;
      notifyListeners();

      final paymentList = await PaymentHistoryService.getAllPayments();
      _payments = paymentList;

      _loading = false;
      print("✅ PaymentHistoryProvider.fetchAllPayments() successful - Found ${_payments.length} payments");
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      print("❌ PaymentHistoryProvider.fetchAllPayments() failed: $e");
      print("📋 Error type: ${e.runtimeType}");
      notifyListeners();
    }
  }

  // ==================== FETCH LAST PAYMENT (if needed) ====================
  Future<void> fetchLastPayment() async {
    try {
      print("🔄 PaymentHistoryProvider.fetchLastPayment() started");
      _loading = true;
      _error = null;
      notifyListeners();

      final payment = await PaymentHistoryService.getLastPayment();
      if (payment != null) {
        _payments = [payment];
      } else {
        _payments = [];
      }

      _loading = false;
      print("✅ PaymentHistoryProvider.fetchLastPayment() successful - Found ${_payments.length} payments");
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      print("❌ PaymentHistoryProvider.fetchLastPayment() failed: $e");
      notifyListeners();
    }
  }

  // ==================== GET LATEST PAYMENT ====================
  PaymentHistoryModel? get latestPayment {
    if (_payments.isEmpty) return null;
    _payments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _payments.first;
  }

  // ==================== GET PAYMENTS BY STATUS ====================
  List<PaymentHistoryModel> getPaymentsByStatus(String status) {
    return _payments.where((payment) => payment.paymentStatus.toLowerCase() == status.toLowerCase()).toList();
  }

  // ==================== GET SUCCESSFUL PAYMENTS ====================
  List<PaymentHistoryModel> get successfulPayments {
    return getPaymentsByStatus('success') +
        getPaymentsByStatus('completed') +
        getPaymentsByStatus('paid');
  }

  // ==================== GET FAILED PAYMENTS ====================
  List<PaymentHistoryModel> get failedPayments {
    return getPaymentsByStatus('failed') +
        getPaymentsByStatus('cancelled') +
        getPaymentsByStatus('declined');
  }

  // ==================== GET PENDING PAYMENTS ====================
  List<PaymentHistoryModel> get pendingPayments {
    return getPaymentsByStatus('pending');
  }

  // ==================== GET RECENT PAYMENTS (last 10) ====================
  List<PaymentHistoryModel> get recentPayments {
    if (_payments.isEmpty) return [];
    _payments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _payments.take(10).toList();
  }

  // ==================== CLEAR DATA ====================
  void clear() {
    print("🔄 PaymentHistoryProvider.clear() called");
    _payments = [];
    _error = null;
    notifyListeners();
  }

  // ==================== REFRESH ====================
  Future<void> refresh() async {
    print("🔄 PaymentHistoryProvider.refresh() called");
    await fetchAllPayments();
  }

  // ==================== HAS PAYMENTS ====================
  bool get hasPayments => _payments.isNotEmpty;

  // ==================== TOTAL PAYMENTS COUNT ====================
  int get totalPayments => _payments.length;

  // ==================== TOTAL AMOUNT ====================
  double get totalAmount {
    return _payments.fold(0.0, (sum, payment) => sum + payment.totalPrice);
  }

  // ==================== GET PAYMENTS BY MONTH ====================
  List<PaymentHistoryModel> getPaymentsByMonth(int year, int month) {
    return _payments.where((payment) =>
    payment.createdAt.year == year && payment.createdAt.month == month
    ).toList();
  }

  // ==================== GET CURRENT MONTH PAYMENTS ====================
  List<PaymentHistoryModel> get currentMonthPayments {
    final now = DateTime.now();
    return getPaymentsByMonth(now.year, now.month);
  }

  // ==================== SEARCH PAYMENTS ====================
  List<PaymentHistoryModel> searchPayments(String query) {
    if (query.isEmpty) return _payments;

    final lowerQuery = query.toLowerCase();
    return _payments.where((payment) =>
    payment.paymentId.toString().contains(lowerQuery) ||
        payment.orderId.toString().contains(lowerQuery) ||
        payment.transactionId.toLowerCase().contains(lowerQuery) ||
        payment.paymentStatus.toLowerCase().contains(lowerQuery) ||
        (payment.method?.toLowerCase().contains(lowerQuery) ?? false)
    ).toList();
  }
}