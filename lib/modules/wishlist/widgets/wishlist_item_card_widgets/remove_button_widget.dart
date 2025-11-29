import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/wishlist/models/wishlist.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

import 'remove_confirmation_dialog.dart';

class RemoveButtonWidget extends StatelessWidget {
  final WishlistModel item;
  final WishlistProvider wishlistProvider;
  final bool isSelected;

  const RemoveButtonWidget({
    super.key,
    required this.item,
    required this.wishlistProvider,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => RemoveConfirmationDialog(
            item: item,
            wishlistProvider: wishlistProvider,
          ),
        );
      },
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue.shade300 : Colors.blue.shade200, // Only blue
            width: 1,
          ),
        ),
        child: Icon(
          Icons.close,
          color: Colors.blue.shade900,
          size: 18,
        ),
      ),
      tooltip: 'Remove from wishlist',
    );
  }
}