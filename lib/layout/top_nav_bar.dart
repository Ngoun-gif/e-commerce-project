import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        // -------------------------------------------------------------
        // BADGE ONLY REBUILDS WHEN badgeCount CHANGES
        // -------------------------------------------------------------
        Selector<CartProvider, int>(
          selector: (_, provider) => provider.badgeCount,
          builder: (context, count, child) {
            return IconButton(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart, color: Colors.white),

                  if (count > 0)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: count > 99
                              ? BoxShape.rectangle
                              : BoxShape.circle,
                          borderRadius:
                          count > 99 ? BorderRadius.circular(8) : null,
                        ),
                        child: Text(
                          count > 99 ? "99+" : count.toString(),
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
              onPressed: () async {
                return requireLogin(
                  context,
                      () => Navigator.pushNamed(context, AppRoutes.cart),
                );
              },
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
