import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/wishlist/models/wishlist.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_ecom/theme/app_colors.dart';
import 'package:provider/provider.dart';


class RemoveConfirmationDialog extends StatelessWidget {
  final WishlistModel item;
  final WishlistProvider wishlistProvider;

  const RemoveConfirmationDialog({
    super.key,
    required this.item,
    required this.wishlistProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColorsPrimary.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      shadowColor: AppColorsDark.dark.withOpacity(0.1),
      backgroundColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dialog Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColorsDanger.dangerLight.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColorsDanger.danger.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  color: AppColorsDanger.danger,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              // Dialog Title
              Text(
                "Remove from Wishlist?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColorsDark.dark,
                ),
              ),
              const SizedBox(height: 12),
              // Dialog Message
              Text(
                "Are you sure you want to remove this item from your wishlist?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColorsSecondary.secondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              // Dialog Buttons
              _buildDialogButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColorsSecondary.secondary,
              side: BorderSide(
                color: AppColorsLight.light2,
                width: 1.5,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.white,
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              wishlistProvider.remove(item.productId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${item.title} removed from wishlist"),
                  backgroundColor: AppColorsDanger.danger,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorsDanger.danger,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Remove",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}