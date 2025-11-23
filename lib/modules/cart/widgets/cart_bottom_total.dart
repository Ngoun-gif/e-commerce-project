// lib/modules/cart/widgets/cart_bottom_total.dart

import 'package:flutter/material.dart';
import '../provider/cart_provider.dart';

class CartBottomTotal extends StatelessWidget {
  final CartProvider provider;

  const CartBottomTotal({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final total = provider.cart?.totalPrice ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // TOTAL
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  "\$${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // CHECKOUT BUTTON
            ElevatedButton(
              onPressed: provider.isEmpty || provider.isMutating
                  ? null
                  : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Checkout coming soon!"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: provider.isMutating
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
                  : const Text(
                "Checkout",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
