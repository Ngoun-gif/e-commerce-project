// lib/modules/cart/widgets/cart_bottom_total.dart

import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/checkout/screens/checkout_screen.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';

class CartBottomTotal extends StatelessWidget {
  final CartProvider provider;

  const CartBottomTotal({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final total = provider.cart?.totalPrice ?? 0;
    final itemCount = provider.cart?.items.length ?? 0;
    final isDisabled = provider.isEmpty || provider.isMutating;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ------------------------------
            // HEADER
            // ------------------------------
            Row(
              children: [
                Icon(Icons.receipt_long_rounded, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  "Order Summary",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const Spacer(),
                Text(
                  "$itemCount ${itemCount == 1 ? 'item' : 'items'}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ------------------------------
            // TOTAL AMOUNT BOX
            // ------------------------------
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "\$${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // ------------------------------
                  // CHECKOUT BUTTON
                  // ------------------------------
                  SizedBox(
                    width: 140,
                    child: ElevatedButton(
                      onPressed: isDisabled
                          ? null
                          : () {
                        // Navigate to checkout
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CheckoutScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: provider.isMutating
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_forward_rounded, size: 18),
                          SizedBox(width: 6),
                          Text(
                            "Checkout",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // ------------------------------
            // SECURITY FOOTER
            // ------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_user_rounded,
                    color: Colors.green.shade600, size: 14),
                const SizedBox(width: 4),
                Text(
                  "Secure payment • Free shipping",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
