import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'wishlist_item_card_widgets/wishlist_item_content.dart';
import 'wishlist_item_card_widgets/wishlist_item_background.dart';
import 'package:flutter_ecom/modules/wishlist/models/wishlist.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_ecom/modules/cart/provider/cart_provider.dart';

class WishlistItemCard extends StatefulWidget {
  final WishlistModel item;
  const WishlistItemCard({super.key, required this.item});

  @override
  State<WishlistItemCard> createState() => _WishlistItemCardState();
}

class _WishlistItemCardState extends State<WishlistItemCard> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = context.watch<WishlistProvider>();
    final cartProvider = context.read<CartProvider>();

    return WishlistItemBackground(
      isSelected: _isSelected,
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: WishlistItemContent(
        item: widget.item,
        wishlistProvider: wishlistProvider,
        cartProvider: cartProvider,
        isSelected: _isSelected,
      ),
    );
  }
}