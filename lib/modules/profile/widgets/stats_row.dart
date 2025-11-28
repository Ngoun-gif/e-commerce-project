import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecom/theme/app_colors.dart';
import 'package:flutter_ecom/modules/payment_history/provider/payment_history_provider.dart';
import 'package:flutter_ecom/modules/cart/provider/cart_provider.dart';


class StatsRow extends StatelessWidget {
  final bool showLoading;
  final VoidCallback? onPaymentTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onWishlistTap;

  const StatsRow({
    super.key,
    this.showLoading = true,
    this.onPaymentTap,
    this.onCartTap,
    this.onWishlistTap,
  });

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentHistoryProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onPaymentTap,
            child: _buildStatItem(
              context: context,
              value: paymentProvider.totalPayments.toString(),
              label: "Payments",
              icon: Icons.payment_outlined,
              loading: showLoading && paymentProvider.loading,

            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onCartTap,
            child: _buildStatItem(
              context: context,
              value: cartProvider.badgeCount.toString(),
              label: "Carts",
              icon: Icons.shopping_cart_outlined,
              loading: showLoading && cartProvider.isCartLoading,

            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onWishlistTap,
            child: _buildStatItem(
              context: context,
              value: wishlistProvider.itemCount.toString(),
              label: "Wishlist",
              icon: Icons.favorite_outline,
              loading: showLoading && wishlistProvider.loading,
              subtitle: wishlistProvider.isAuthenticated ? "" : "Login required",
            ),
          ),
        ),
      ],
    );
  }

  String _getPaymentSubtitle(PaymentHistoryProvider provider) {
    if (provider.successfulPayments.isNotEmpty) {
      return "${provider.successfulPayments.length} successful";
    }
    return "";
  }



  Widget _buildStatItem({
    required BuildContext context,
    required String value,
    required String label,
    required IconData icon,
    bool loading = false,
    String subtitle = "",
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(height: 8),
          if (loading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          else
            Column(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}