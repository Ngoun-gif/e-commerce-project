// lib/modules/cart/widgets/cart_body.dart

import 'package:flutter/material.dart';
import 'package:flutter_ecom/layout/bottom_bar_layout.dart';
import 'package:flutter_ecom/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import 'cart_item_tile.dart';
import 'package:flutter_ecom/utils/require_login.dart';


class CartBody extends StatelessWidget {
  final CartProvider provider;

  const CartBody({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    // CART LOADING (first load)
    if (provider.isCartLoading && provider.cart == null) {
      return _buildLoadingState();
    }

    // ERROR UI
    if (provider.error != null) {
      return _buildErrorState(context);
    }

    // EMPTY CART
    if (provider.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildCartItems();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Loading your cart...",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final isAuthError = _isAuthError(provider.error);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Text(
              isAuthError ? "Authentication Required" : "Oops! Something went wrong",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                provider.error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isAuthError ? Colors.orange.shade600 : Colors.grey.shade600,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (isAuthError) ...[
              // Login button for auth errors
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _handleLogin(context),
                  icon: const Icon(Icons.login_rounded, size: 20),
                  label: const Text(
                    "Login to Continue",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),

            ] else ...[
              // Retry button for other errors
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: provider.loadCart,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text(
                    "Try Again",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Your cart is empty",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Browse our products and add items to get started",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const BottomBarLayout(initialIndex: 0),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                label: const Text(
                  "Start Shopping",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItems() {
    return Column(
      children: [
        // HEADER WITH ITEM COUNT
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.shopping_cart_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Cart Items (${provider.cart!.items.length})",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const Spacer(),
              if (provider.isMutating)
                Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Updating...",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),

        // CART ITEMS LIST
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => provider.loadCart(),
            color: AppColors.primary,
            backgroundColor: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.cart!.items.length,
              itemBuilder: (_, index) {
                final item = provider.cart!.items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: CartItemTile(
                    item: item,
                    isMutating: provider.isMutating,
                    onIncrease: () => provider.increase(item.id),
                    onDecrease: () => provider.decrease(item.id),
                    onRemove: () => provider.remove(item.id),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
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
}