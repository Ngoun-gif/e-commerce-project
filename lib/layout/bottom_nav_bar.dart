import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bottom_bar_layout.dart';
import 'package:flutter_ecom/modules/cart/provider/cart_provider.dart';
import 'package:flutter_ecom/modules/auth/providers/auth_provider.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthProvider, CartProvider, WishlistProvider>(
      builder: (context, authProvider, cartProvider, wishlistProvider, child) {
        final isLoggedIn = authProvider.isAuthenticated;
        final cartBadgeCount = isLoggedIn ? cartProvider.badgeCount : 0;
        final wishlistBadgeCount = isLoggedIn ? wishlistProvider.itemCount : 0; // Use itemCount

        return BottomNavigationBar(
          currentIndex: BottomBarLayout.currentIndex,
          selectedItemColor: const Color(0xFF0D47A1),
          unselectedItemColor: Colors.grey,
          onTap: (i) {
            setState(() => BottomBarLayout.currentIndex = i);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const BottomBarLayout()),
            );
          },
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: "Home"
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                label: "Category"
            ),
            BottomNavigationBarItem(
              icon: _buildWishlistIconWithBadge(wishlistBadgeCount),
              label: "Wishlist",
            ),
            BottomNavigationBarItem(
              icon: _buildCartIconWithBadge(cartBadgeCount),
              label: "Cart",
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: "Profile"
            ),
          ],
        );
      },
    );
  }

  Widget _buildCartIconWithBadge(int badgeCount) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.shopping_cart_outlined),
        // Cart Badge - Red color
        if (badgeCount > 0)
          Positioned(
            right: -8,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: badgeCount > 99 ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: badgeCount > 99 ? BorderRadius.circular(8) : null,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badgeCount > 99 ? '99+' : badgeCount.toString(),
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

  Widget _buildWishlistIconWithBadge(int badgeCount) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.favorite_border),
        // Wishlist Badge - Pink color to match the heart theme
        if (badgeCount > 0)
          Positioned(
            right: -8,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.pink, // Pink color for wishlist
                shape: badgeCount > 99 ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: badgeCount > 99 ? BorderRadius.circular(8) : null,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badgeCount > 99 ? '99+' : badgeCount.toString(),
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