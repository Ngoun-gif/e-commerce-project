import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/models/product.dart';
import '../../../utils/require_login.dart';
import '../../cart/provider/cart_provider.dart';
import 'package:flutter_ecom/routers/app_routes.dart';

class ProductDetailBottomBar extends StatelessWidget {
  final ProductModel product;

  const ProductDetailBottomBar({
    super.key,
    required this.product,
  });

  // -------------------------------------------------------------
  // GET CURRENT QUANTITY
  // -------------------------------------------------------------
  int _getCurrentQuantity(CartProvider provider) {
    if (provider.cart == null) return 0;
    for (final item in provider.cart!.items) {
      if (item.productId == product.id) return item.quantity;
    }
    return 0;
  }

  // -------------------------------------------------------------
  // GET CART ITEM ID
  // -------------------------------------------------------------
  int? _getItemId(CartProvider provider) {
    if (provider.cart == null) return null;
    for (final item in provider.cart!.items) {
      if (item.productId == product.id) return item.id;
    }
    return null;
  }

  // -------------------------------------------------------------
  // ADD TO CART
  // -------------------------------------------------------------
  Future<void> _addToCart(BuildContext context) async {
    return requireLogin(context, () async {
      final provider = Provider.of<CartProvider>(context, listen: false);
      await provider.add(product.id, 1);

      if (provider.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Added to cart!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  // -------------------------------------------------------------
  // UPDATE QTY OR REMOVE
  // -------------------------------------------------------------
  Future<void> _updateQuantity(BuildContext context, int newQty) async {
    return requireLogin(context, () async {
      final provider = Provider.of<CartProvider>(context, listen: false);
      final itemId = _getItemId(provider);

      if (itemId == null) return;

      if (newQty == 0) {
        await provider.remove(itemId);
      } else {
        await provider.update(itemId, newQty);
      }
    });
  }

  // -------------------------------------------------------------
  // BUILD UI
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        final qty = _getCurrentQuantity(provider);
        final isMutating = provider.isMutating;

        return Container(
          height: 90,
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
          child: Row(
            children: [
              if (qty > 0) ...[
                _buildQtySelector(context, qty, provider),
                const SizedBox(width: 12),
              ],
              _buildMainButton(context, qty, isMutating),
            ],
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------
  // QUANTITY SELECTOR
  // -------------------------------------------------------------
  Widget _buildQtySelector(
      BuildContext context, int qty, CartProvider provider) {
    final isMutating = provider.isMutating;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          IconButton(
            icon: isMutating
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.remove, size: 20),
            onPressed: isMutating ? null : () => _updateQuantity(context, qty - 1),
            padding: EdgeInsets.zero,
          ),

          Text(
            qty.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          IconButton(
            icon: const Icon(Icons.add, size: 20),
            onPressed: (!isMutating && qty < product.stockQuantity)
                ? () => _updateQuantity(context, qty + 1)
                : null,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // MAIN BUTTON
  // -------------------------------------------------------------
  Widget _buildMainButton(BuildContext context, int qty, bool isMutating) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: product.outOfStock || isMutating
              ? null
              : () {
            if (qty == 0) {
              _addToCart(context);
            } else {
              Navigator.pushNamed(context, AppRoutes.cart);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D47A1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isMutating
              ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.white,
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                qty == 0
                    ? Icons.shopping_cart_outlined
                    : Icons.shopping_cart,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                qty == 0 ? "Add to Cart" : "View in Cart",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
