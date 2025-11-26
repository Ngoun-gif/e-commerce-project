import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/payment_history/models/payment_history_model.dart';


class PaymentSummaryCard extends StatelessWidget {
  final List<PaymentHistoryModel> payments;

  const PaymentSummaryCard({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    final totalAmount = payments.fold(0.0, (sum, payment) => sum + payment.totalPrice);
    final successfulPayments = payments.where((p) => p.paymentStatus.toLowerCase() == 'paid').length;
    final failedPayments = payments.where((p) =>
    p.paymentStatus.toLowerCase() == 'failed' ||
        p.paymentStatus.toLowerCase() == 'cancelled'
    ).length;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Payment Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem("Total", payments.length.toString(), Icons.list_alt),
                _buildSummaryItem("Success", successfulPayments.toString(), Icons.check_circle, color: Colors.green),
                _buildSummaryItem("Failed", failedPayments.toString(), Icons.error, color: Colors.red),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.attach_money, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Total Amount: ${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? const Color(0xFF0D47A1), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color ?? const Color(0xFF0D47A1),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}