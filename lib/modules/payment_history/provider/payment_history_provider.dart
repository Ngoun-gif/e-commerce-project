import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/payment_history/models/payment_history_model.dart';
import '../services/payment_history_service.dart';

class PaymentHistoryProvider extends ChangeNotifier {
  List<PaymentHistoryModel> _payments = [];
  bool _loading = false;
  String? _error;
  bool _isAuthenticated = false;

  // Getters
  List<PaymentHistoryModel> get payments => _payments;
  bool get loading => _loading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  // ==================== NEW: SIMPLE COUNT GETTER ====================
  int get count => _payments.length;

  // ==================== UPDATE AUTH STATE ====================
  void updateAuthState(bool authenticated) {
    if (_isAuthenticated != authenticated) {
      _isAuthenticated = authenticated;
      print("🔄 PaymentHistoryProvider.updateAuthState() - Authenticated: $authenticated");

      if (authenticated) {
        // Auto-fetch payments when user logs in for count display
        _fetchPaymentsForCount();
      } else {
        // Clear payments when user logs out
        _payments = [];
        _error = null;
      }
      notifyListeners();
    }
  }

  // ==================== AUTO-FETCH FOR COUNT DISPLAY ====================
  Future<void> _fetchPaymentsForCount() async {
    if (!_isAuthenticated) return;

    try {
      print("🔄 PaymentHistoryProvider._fetchPaymentsForCount() - Fetching payments for count");
      _loading = true;
      _error = null;
      notifyListeners();

      final paymentList = await PaymentHistoryService.getAllPayments();
      _payments = paymentList;

      _loading = false;
      print("✅ PaymentHistoryProvider._fetchPaymentsForCount() - Found ${_payments.length} payments for count display");
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      print("❌ PaymentHistoryProvider._fetchPaymentsForCount() - Failed to fetch payments: $e");
      notifyListeners();
    }
  }

  // ==================== FETCH ALL PAYMENTS ====================
  Future<void> fetchAllPayments() async {
    if (!_isAuthenticated) {
      _error = "Please login to view payment history";
      notifyListeners();
      return;
    }

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
    if (!_isAuthenticated) {
      _error = "Please login to view payment history";
      notifyListeners();
      return;
    }

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
    if (!_isAuthenticated) return 0.0;
    return _payments.fold(0.0, (sum, payment) => sum + payment.totalPrice);
  }

  // ==================== GET PAYMENTS BY MONTH ====================
  List<PaymentHistoryModel> getPaymentsByMonth(int year, int month) {
    if (!_isAuthenticated) return [];
    return _payments.where((payment) =>
    payment.createdAt.year == year && payment.createdAt.month == month
    ).toList();
  }

  // ==================== GET CURRENT MONTH PAYMENTS ====================
  List<PaymentHistoryModel> get currentMonthPayments {
    if (!_isAuthenticated) return [];
    final now = DateTime.now();
    return getPaymentsByMonth(now.year, now.month);
  }

  // ==================== SEARCH PAYMENTS ====================
  List<PaymentHistoryModel> searchPayments(String query) {
    if (!_isAuthenticated) return [];
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