import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/cart/provider/cart_provider.dart';
import 'package:flutter_ecom/modules/wishlist/models/wishlist.dart';
import 'package:flutter_ecom/theme/app_colors.dart';
import 'package:provider/provider.dart';

class CartOperations {
  static Future<void> addToCart(
      BuildContext context,
      CartProvider cartProvider,
      WishlistModel item,
      ) async {
    if (cartProvider.isMutating) {
      _showSnackBar(
        context,
        "Please wait...",
        AppColorsInfo.infoLight, // Loading state
      );
      return;
    }

    try {
      _showSnackBar(
        context,
        "Adding ${item.title} to cart...",
        AppColorsInfo.info, // Loading state
      );

      await cartProvider.add(item.productId, 1);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showSnackBar(
        context,
        "${item.title} added to cart!",
        AppColorsSuccess.success, // Success state
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showSnackBar(
        context,
        "Failed to add ${item.title} to cart",
        AppColorsDanger.danger, // Error state
        duration: const Duration(seconds: 3),
      );
    }
  }

  static void _showSnackBar(
      BuildContext context,
      String message,
      Color backgroundColor, {
        SnackBarAction? action,
        Duration duration = const Duration(seconds: 2),
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: action,
      ),
    );
  }

  // Optional: You can also create specific methods for different states
  static void showLoadingSnackBar(BuildContext context, String message) {
    _showSnackBar(context, message, AppColorsInfo.info);
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      AppColorsSuccess.success,
      duration: const Duration(seconds: 3),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      AppColorsDanger.danger,
      duration: const Duration(seconds: 3),
    );
  }

  static void showWarningSnackBar(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      AppColorsWarning.warning,
      duration: const Duration(seconds: 3),
    );
  }
}