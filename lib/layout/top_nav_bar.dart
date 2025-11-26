// lib/widgets/top_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ecom/modules/auth/providers/auth_provider.dart';
import 'package:flutter_ecom/modules/cart/provider/cart_provider.dart';
import 'package:flutter_ecom/routers/app_routes.dart';
import 'package:flutter_ecom/utils/require_login.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const TopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0D47A1),
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        "E-Shop",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // COMBINE AUTH + CART PROVIDERS
        Consumer2<AuthProvider, CartProvider>(
          builder: (context, authProvider, cartProvider, child) {
            final isLoggedIn = authProvider.isAuthenticated;
            final badgeCount = isLoggedIn ? cartProvider.badgeCount : 0;

            return IconButton(
              onPressed: () async {
                if (!isLoggedIn) {
                  // Show login dialog for non-authenticated users
                  return requireLogin(
                    context,
                        () async {
                      // After successful login, load cart and navigate
                      await cartProvider.loadCart();
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                      Navigator.pushNamed(context, AppRoutes.cart);
                    },
                  );
                } else {
                  // User is logged in - refresh cart and navigate
                  await cartProvider.loadCart();
                  Navigator.pushNamed(context, AppRoutes.cart);
                }
              },
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart, color: Colors.white),

                  // ONLY SHOW BADGE WHEN LOGGED IN AND HAS ITEMS
                  if (isLoggedIn && badgeCount > 0)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: badgeCount > 99
                              ? BoxShape.rectangle
                              : BoxShape.circle,
                          borderRadius: badgeCount > 99
                              ? BorderRadius.circular(8)
                              : null,
                        ),
                        child: Text(
                          badgeCount > 99 ? "99+" : badgeCount.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}