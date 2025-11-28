// lib/modules/payment/provider/payment_provider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/payment/model/payment.dart';
import 'package:flutter_ecom/modules/payment/services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  PaymentModel? lastPayment;
  bool loading = false;
  String? error;

  // ==================== PAY ====================
  Future<bool> pay(int orderId, String method) async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      final payment = await PaymentService.pay(orderId, method)
          .timeout(const Duration(seconds: 30));

      lastPayment = payment;
      loading = false;
      notifyListeners();

      return true;
    } on TimeoutException {
      loading = false;
      error = "Payment timeout. Please check your connection and try again.";
      notifyListeners();
      return false;
    } catch (e) {
      loading = false;
      error = _getUserFriendlyErrorMessage(e.toString());
      notifyListeners();
      return false;
    }
  }

  // ==================== LAST PAYMENT ====================
  Future<void> fetchLastPayment() async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      final payment = await PaymentService.getLastPayment()
          .timeout(const Duration(seconds: 15));

      lastPayment = payment;
      loading = false;
      notifyListeners();
    } on TimeoutException {
      loading = false;
      error = "Request timeout. Please try again.";
      notifyListeners();
    } catch (e) {
      loading = false;
      error = _getUserFriendlyErrorMessage(e.toString());
      notifyListeners();
    }
  }

  // ==================== USER-FRIENDLY ERROR MESSAGES ====================
  String _getUserFriendlyErrorMessage(String error) {
    if (error.contains('timeout') || error.contains('Timeout')) {
      return "Request timeout. Please check your connection and try again.";
    } else if (error.contains('network') || error.contains('socket')) {
      return "Network error. Please check your internet connection.";
    } else if (error.contains('card') || error.contains('payment') || error.contains('transaction')) {
      return "Payment failed. Please check your payment details and try again.";
    } else if (error.contains('401') || error.contains('unauthorized')) {
      return "Session expired. Please login again.";
    } else if (error.contains('500') || error.contains('server')) {
      return "Server error. Please try again later.";
    } else if (error.contains('404') || error.contains('not found')) {
      return "Service unavailable. Please try again later.";
    } else if (error.contains('insufficient') || error.contains('balance')) {
      return "Insufficient funds. Please check your balance.";
    } else if (error.contains('declined') || error.contains('rejected')) {
      return "Payment was declined. Please try a different payment method.";
    } else {
      return "Payment failed. Please try again.";
    }
  }

  // ==================== RESET ====================
  void clear() {
    lastPayment = null;
    error = null;
    notifyListeners();
  }

  // ==================== CHECK IF HAS PAYMENT ====================
  bool get hasPayment => lastPayment != null;

  // ==================== GET PAYMENT STATUS ====================
  String? get paymentStatus => lastPayment?.paymentStatus;

  // ==================== IS PAYMENT SUCCESSFUL ====================
  bool get isPaymentSuccessful {
    final status = lastPayment?.paymentStatus?.toLowerCase();
    return status == 'success' || status == 'completed' || status == 'paid' || status == 'approved';
  }

  // ==================== IS PAYMENT PENDING ====================
  bool get isPaymentPending {
    final status = lastPayment?.paymentStatus?.toLowerCase();
    return status == 'pending' || status == 'processing' || status == 'waiting';
  }

  // ==================== IS PAYMENT FAILED ====================
  bool get isPaymentFailed {
    final status = lastPayment?.paymentStatus?.toLowerCase();
    return status == 'failed' || status == 'declined' || status == 'cancelled' || status == 'rejected';
  }
}