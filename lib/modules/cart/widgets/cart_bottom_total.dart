// lib/modules/cart/widgets/cart_bottom_total.dart

import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/checkout/screens/checkout_screen.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import 'package:flutter_ecom/utils/require_login.dart';
import 'package:flutter_ecom/modules/auth/providers/auth_provider.dart'; // Add this import

class CartBottomTotal extends StatelessWidget {
  final CartProvider provider;

  const CartBottomTotal({super.key, required this.provider});

  // Helper to format currency
  String _formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  // Helper to get item count text
  String _getItemCountText(int count) {
    return '$count ${count == 1 ? 'item' : 'items'}';
  }

  // Helper to get tooltip message
  String _getTooltipMessage(bool isEmpty, bool hasError, bool isAuthError) {
    if (isEmpty) return "Cart is empty";
    if (hasError) return isAuthError ? "Please login to continue" : "Please fix errors";
    return "Proceed to checkout";
  }

  // Check if error is authentication related
  bool _isAuthError(String? error) {
    return error?.toLowerCase().contains('login') == true ||
        error?.toLowerCase().contains('authenticate') == true ||
        error?.toLowerCase().contains('please login') == true;
  }

  // Handle login action
  void _handleLogin(BuildContext context) {
    requireLogin(
      context,
          () async {
        // After successful login, reload the cart
        await provider.loadCart();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isLoggedIn = authProvider.isAuthenticated;

    final cart = isLoggedIn ? provider.cart : null; // Clear cart data when not logged in
    final total = isLoggedIn ? (cart?.totalPrice ?? 0.0) : 0.0; // Force 0 when not logged in
    final itemCount = isLoggedIn ? (cart?.items.length ?? 0) : 0; // Force 0 when not logged in
    final hasError = provider.error != null;
    final isAuthError = _isAuthError(provider.error);
    final isDisabled = !isLoggedIn || provider.isEmpty || provider.isMutating || hasError;

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
                Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
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
                  _getItemCountText(itemCount),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ------------------------------
            // ERROR MESSAGE - YELLOW/WARNING FOR AUTH ERRORS
            // ------------------------------
            if (hasError) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: isAuthError ? Colors.orange.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isAuthError ? Colors.orange.shade200 : Colors.red.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isAuthError ? Icons.warning_amber_rounded : Icons.error_outline_rounded,
                      color: isAuthError ? Colors.orange.shade600 : Colors.red.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.error!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isAuthError ? Colors.orange.shade800 : Colors.red.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Show different actions based on error type
                    if (!provider.isMutating)
                      TextButton(
                        onPressed: isAuthError
                            ? () => _handleLogin(context)
                            : () => provider.loadCart(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                        ),
                        child: Text(
                          isAuthError ? "Login" : "Retry",
                          style: TextStyle(
                            fontSize: 12,
                            color: isAuthError ? Colors.orange.shade800 : Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            // ------------------------------
            // TOTAL AMOUNT BOX - YELLOW FOR AUTH ERRORS
            // ------------------------------
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: !isLoggedIn || hasError
                    ? (isAuthError ? Colors.orange.shade50 : Colors.grey.shade100)
                    : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: !isLoggedIn || hasError
                      ? (isAuthError ? Colors.orange.shade200 : Colors.grey.shade300)
                      : Colors.blue.shade100,
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Amount",
                        style: TextStyle(
                          fontSize: 13,
                          color: !isLoggedIn || hasError
                              ? (isAuthError ? Colors.orange.shade700 : Colors.grey.shade500)
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        !isLoggedIn ? "Please login to view" : _formatPrice(total),
                        style: TextStyle(
                          fontSize: !isLoggedIn ? 16 : 24,
                          fontWeight: FontWeight.w700,
                          color: !isLoggedIn
                              ? Colors.grey.shade500
                              : (hasError
                              ? (isAuthError ? Colors.orange.shade700 : Colors.red)
                              : Colors.green),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // ------------------------------
                  // CHECKOUT BUTTON WITH TOOLTIP - YELLOW FOR AUTH ERRORS
                  // ------------------------------
                  SizedBox(
                    width: 140,
                    child: Tooltip(
                      message: !isLoggedIn
                          ? "Please login to continue"
                          : _getTooltipMessage(provider.isEmpty, hasError, isAuthError),
                      child: ElevatedButton(
                        onPressed: isDisabled
                            ? null
                            : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CheckoutScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !isLoggedIn || hasError
                              ? (isAuthError ? Colors.orange.shade600 : Colors.grey.shade400)
                              : const Color(0xFF0D47A1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: (!isLoggedIn || hasError) ? 0 : 2,
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
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              !isLoggedIn
                                  ? Icons.login_rounded
                                  : (hasError
                                  ? (isAuthError ? Icons.login_rounded : Icons.error_outline)
                                  : Icons.arrow_forward_rounded),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              !isLoggedIn
                                  ? "Login"
                                  : (hasError
                                  ? (isAuthError ? "Login" : "Error")
                                  : "Checkout"),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // ------------------------------
            // SECURITY FOOTER - Only show when logged in and no errors
            // ------------------------------
            if (isLoggedIn && !hasError)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_user_rounded,
                    color: Colors.green.shade600,
                    size: 14,
                  ),
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