import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ecom/modules/cart/provider/cart_provider.dart';
import 'package:flutter_ecom/modules/auth/providers/auth_provider.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChange;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthProvider, CartProvider, WishlistProvider>(
      builder: (context, authProvider, cartProvider, wishlistProvider, child) {

        // Ensure wishlist provider is synced with auth state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (wishlistProvider.isAuthenticated != authProvider.isAuthenticated) {
            print("🔄 BottomNavBar - Syncing wishlist auth state");
            wishlistProvider.updateAuthState(authProvider.isAuthenticated);
          }
        });

        final isLoggedIn = authProvider.isAuthenticated;
        final cartBadgeCount = isLoggedIn ? cartProvider.badgeCount : 0;
        final wishlistBadgeCount = isLoggedIn ? wishlistProvider.itemCount : 0;

        print("📊 BottomNavBar - Auth: $isLoggedIn, Wishlist: $wishlistBadgeCount, Cart: $cartBadgeCount");

        return BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF0D47A1),
          unselectedItemColor: Colors.grey,
          onTap: onTabChange,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_grid_2x2),
              label: "Category",
            ),
            BottomNavigationBarItem(
              icon: _badgeIcon(Icons.favorite_border, wishlistBadgeCount, Colors.pink),
              label: "Wishlist",
            ),
            BottomNavigationBarItem(
              icon: _badgeIcon(Icons.shopping_cart_outlined, cartBadgeCount, Colors.red),
              label: "Cart",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
          ],
        );
      },
    );
  }

  static Widget _badgeIcon(IconData icon, int badgeCount, Color color) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (badgeCount > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badgeCount > 99 ? "99+" : badgeCount.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}