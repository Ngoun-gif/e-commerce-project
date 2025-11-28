import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/cart/provider/cart_provider.dart';
import 'package:flutter_ecom/modules/wishlist/models/wishlist.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';


import 'product_image_widget.dart';
import 'product_info_widget.dart';
import 'remove_button_widget.dart';

class WishlistItemContent extends StatelessWidget {
  final WishlistModel item;
  final WishlistProvider wishlistProvider;
  final CartProvider cartProvider;
  final bool isSelected;

  const WishlistItemContent({
    super.key,
    required this.item,
    required this.wishlistProvider,
    required this.cartProvider,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Product Image
          ProductImageWidget(item: item, isSelected: isSelected),
          const SizedBox(width: 16),
          // Product Info
          Expanded(
            child: ProductInfoWidget(
              item: item,
              cartProvider: cartProvider,
              isSelected: isSelected,
            ),
          ),
          // Remove Button
          RemoveButtonWidget(
            item: item,
            wishlistProvider: wishlistProvider,
            isSelected: isSelected,
          ),
        ],
      ),
    );
  }
}