// lib/modules/payment/widgets/payment_loading_screen_widget.dart

import 'package:flutter/material.dart';

class PaymentLoadingScreen extends StatelessWidget {
  const PaymentLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.85),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Loading spinner
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.green.shade400,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Loading text
              Text(
                "Processing Payment...",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle text
              Text(
                "Please wait while we securely process your payment",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}