import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/cart/provider/cart_provider.dart';
import 'package:flutter_ecom/modules/wishlist/models/wishlist.dart';
import 'package:provider/provider.dart';

import 'cart_operations.dart';

class ProductInfoWidget extends StatelessWidget {
  final WishlistModel item;
  final CartProvider cartProvider;
  final bool isSelected;

  const ProductInfoWidget({
    super.key,
    required this.item,
    required this.cartProvider,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Title
        Text(
          item.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.blue.shade800 : Colors.blue.shade700, // Only blue
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        // Price
        Text(
          "\$${item.price.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.blue.shade600 : Colors.blue.shade500, // Only blue
          ),
        ),
        const SizedBox(height: 12),
        // Add to Cart Button
        SizedBox(
          width: 140,
          child: ElevatedButton(
            onPressed: () => CartOperations.addToCart(context, cartProvider, item),
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.blue.shade600 : Colors.blue.shade500, // Only blue
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 16),
                SizedBox(width: 6),
                Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}