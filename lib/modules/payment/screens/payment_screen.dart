// lib/modules/payment/screens/payment_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/payment/widgets/payment_loading_screen_widget.dart';
import 'package:provider/provider.dart';
import '../provider/payment_provider.dart';
import '../widgets/payment_summary_card.dart';
import '../../../routers/app_routes.dart';

class PaymentScreen extends StatelessWidget {
  final int orderId;
  final String method;

  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Main Content
          IgnorePointer(
            ignoring: provider.loading,
            child: AnimatedOpacity(
              opacity: provider.loading ? 0.6 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // ---- SUMMARY CARD ----
                      PaymentSummaryCard(
                        orderId: orderId,
                        method: method,
                      ),
                      const Spacer(),

                      // ---- PAYMENT SECURITY INFO ----
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: Colors.blue.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Your payment is secure and encrypted",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ---- CONFIRM BUTTON ----
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: provider.loading
                              ? null
                              : () => _handlePayment(context, provider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                            shadowColor: Colors.blue.shade200,
                          ),
                          child: provider.loading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            "Confirm Payment",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ---- OVERLAY LOADING SCREEN ----
          if (provider.loading) const PaymentLoadingScreen(),
        ],
      ),
    );
  }

  Future<void> _handlePayment(BuildContext context, PaymentProvider provider) async {
    try {
      final ok = await provider.pay(orderId, method);

      if (!context.mounted) return;

      if (ok) {
        // Check payment status for better UX
        if (provider.isPaymentSuccessful) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.successPayment,
          );
        } else if (provider.isPaymentPending) {
          // Show pending message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Payment is processing. Please wait for confirmation."),
              backgroundColor: Colors.orange.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        } else {
          // Payment completed but status unknown
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.successPayment,
          );
        }
      } else {
        // Show error message with retry option
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? "Payment failed"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                _handlePayment(context, provider);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("An unexpected error occurred"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}