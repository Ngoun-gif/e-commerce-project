import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecom/modules/payment_history/screens/payment_history_screen.dart';
import 'package:flutter_ecom/modules/auth/providers/auth_provider.dart';
import 'package:flutter_ecom/modules/payment_history/provider/payment_history_provider.dart';
import 'package:flutter_ecom/routers/app_routes.dart';

import 'drawer_item.dart';

class DrawerSections extends StatelessWidget {
  final bool isLoggedIn;
  final int cartCount;
  final int wishlistCount;
  final int paymentCount;
  final AuthProvider authProvider;
  final PaymentHistoryProvider paymentProvider;

  const DrawerSections({
    super.key,
    required this.isLoggedIn,
    required this.cartCount,
    required this.wishlistCount,
    required this.paymentCount,
    required this.authProvider,
    required this.paymentProvider,
  });

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  "Confirm Logout",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Message
                const Text(
                  "Are you sure you want to logout from your account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await authProvider.logout();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, AppRoutes.main);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Logout"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 8),

        // ==================== MAIN NAVIGATION ====================
        const SectionTitle(title: "Navigation"),

        DrawerItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          title: "Home",
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.main);
          },
        ),

        DrawerItem(
          icon: Icons.shopping_cart_outlined,
          activeIcon: Icons.shopping_cart,
          title: "My Cart",
          badgeCount: isLoggedIn ? cartCount : null,
          onTap: () {
            Navigator.pop(context);
            if (isLoggedIn) {
              Navigator.pushNamed(context, AppRoutes.cart);
            } else {
              Navigator.pushNamed(context, AppRoutes.login);
            }
          },
        ),

        DrawerItem(
          icon: Icons.favorite_outlined,
          activeIcon: Icons.favorite,
          title: "Wishlist",
          badgeCount: isLoggedIn ? wishlistCount : null,
          onTap: () {
            Navigator.pop(context);
            if (isLoggedIn) {
              Navigator.pushNamed(context, AppRoutes.wishlist);
            } else {
              Navigator.pushNamed(context, AppRoutes.login);
            }
          },
        ),

        // 🔥 PAYMENT HISTORY - Only show if logged in
        if (isLoggedIn) ...[
          DrawerItem(
            icon: Icons.payment_outlined,
            activeIcon: Icons.payment,
            title: "Payment History",
            badgeCount: paymentCount,
            onTap: () {
              // Refresh before navigating
              paymentProvider.refreshImmediately();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentHistoryScreen(),
                ),
              );
            },
          ),
        ],

        // 🔥 MY PROFILE - Only show if logged in
        if (isLoggedIn) ...[
          DrawerItem(
            icon: Icons.person_outlined,
            activeIcon: Icons.person,
            title: "My Profile",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
        ],

        const SizedBox(height: 16),
        const CustomDivider(),

        // ==================== AUTH ACTIONS ====================
        const SectionTitle(title: "Account"),

        // 🔥 DYNAMIC AUTH ACTION - Login/Logout
        DrawerItem(
          icon: isLoggedIn ? Icons.logout_outlined : Icons.login_outlined,
          activeIcon: isLoggedIn ? Icons.logout : Icons.login,
          title: isLoggedIn ? "Logout" : "Login",
          color: isLoggedIn ? Colors.red : const Color(0xFF0D47A1),
          onTap: () {
            Navigator.pop(context);
            if (isLoggedIn) {
              _showLogoutDialog(context);
            } else {
              Navigator.pushNamed(context, AppRoutes.login);
            }
          },
        ),

        // 🔥 REGISTER - Only show if not logged in
        if (!isLoggedIn) ...[
          DrawerItem(
            icon: Icons.person_add_outlined,
            activeIcon: Icons.person_add,
            title: "Create Account",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.register);
            },
          ),
        ],

        const SizedBox(height: 20),
      ],
    );
  }
}