import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/user/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecom/modules/payment_history/screens/payment_history_screen.dart';
import 'package:flutter_ecom/modules/auth/providers/auth_provider.dart';
import 'package:flutter_ecom/modules/cart/provider/cart_provider.dart';
import 'package:flutter_ecom/modules/payment_history/provider/payment_history_provider.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_ecom/routers/app_routes.dart';

class DrawerLayout extends StatelessWidget {
  const DrawerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final paymentProvider = Provider.of<PaymentHistoryProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    final isLoggedIn = authProvider.isAuthenticated;
    final user = authProvider.user;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 🔥 ENHANCED HEADER
          _buildDrawerHeader(
            context,
            isLoggedIn,
            user,
            cartCount: cartProvider.badgeCount,
            wishlistCount: wishlistProvider.itemCount,
            paymentCount: paymentProvider.count,
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),

                // ==================== MAIN NAVIGATION ====================
                _buildSectionTitle("Navigation"),

                _buildEnhancedDrawerItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  title: "Home",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, AppRoutes.main);
                  },
                ),

                _buildEnhancedDrawerItem(
                  icon: Icons.shopping_cart_outlined,
                  activeIcon: Icons.shopping_cart,
                  title: "My Cart",
                  badgeCount: isLoggedIn ? cartProvider.badgeCount : null,
                  onTap: () {
                    Navigator.pop(context);
                    if (isLoggedIn) {
                      Navigator.pushNamed(context, AppRoutes.cart);
                    } else {
                      Navigator.pushNamed(context, AppRoutes.login);
                    }
                  },
                ),

                _buildEnhancedDrawerItem(
                  icon: Icons.favorite_outline,
                  activeIcon: Icons.favorite,
                  title: "Wishlist",
                  badgeCount: isLoggedIn ? wishlistProvider.itemCount : null,
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
                  _buildEnhancedDrawerItem(
                    icon: Icons.payment_outlined,
                    activeIcon: Icons.payment,
                    title: "Payment History",
                    badgeCount: paymentProvider.count,
                    onTap: () {
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
                  _buildEnhancedDrawerItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    title: "My Profile",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                  ),
                ],

                const SizedBox(height: 16),
                _buildDivider(),

                // ==================== APP INFO ====================
                _buildSectionTitle("App Info"),

                _buildEnhancedDrawerItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  title: "Settings",
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Add settings route when ready
                  },
                ),

                _buildEnhancedDrawerItem(
                  icon: Icons.info_outline,
                  activeIcon: Icons.info,
                  title: "About",
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Add about route when ready
                  },
                ),

                const SizedBox(height: 16),
                _buildDivider(),

                // ==================== AUTH ACTIONS ====================
                _buildSectionTitle("Account"),

                // 🔥 DYNAMIC AUTH ACTION - Login/Logout
                _buildEnhancedDrawerItem(
                  icon: isLoggedIn ? Icons.logout_outlined : Icons.login_outlined,
                  activeIcon: isLoggedIn ? Icons.logout : Icons.login,
                  title: isLoggedIn ? "Logout" : "Login",
                  color: isLoggedIn ? Colors.red : const Color(0xFF0D47A1),
                  onTap: () {
                    Navigator.pop(context);
                    if (isLoggedIn) {
                      _showLogoutDialog(context, authProvider);
                    } else {
                      Navigator.pushNamed(context, AppRoutes.login);
                    }
                  },
                ),

                // 🔥 REGISTER - Only show if not logged in
                if (!isLoggedIn) ...[
                  _buildEnhancedDrawerItem(
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
            ),
          ),

          // 🔥 ENHANCED APP INFO
          _buildEnhancedAppInfo(context),
        ],
      ),
    );
  }

  Widget _buildEnhancedDrawerItem({
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required VoidCallback onTap,
    Color? color,
    int? badgeCount,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (color ?? const Color(0xFF0D47A1)).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color ?? const Color(0xFF0D47A1),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color ?? Colors.black87,
          ),
        ),
        trailing: badgeCount != null && badgeCount > 0
            ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF0D47A1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            badgeCount > 99 ? "99+" : badgeCount.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        visualDensity: const VisualDensity(vertical: -2),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        color: Colors.grey.shade300,
        height: 1,
      ),
    );
  }

  Widget _buildDrawerHeader(
      BuildContext context,
      bool isLoggedIn,
      UserModel? user, {
        required int cartCount,
        required int wishlistCount,
        required int paymentCount,
      }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1976D2),
            Color(0xFF42A5F5),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar with Status
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.person,
                  color: const Color(0xFF0D47A1),
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLoggedIn && user != null
                          ? "${user.firstname} ${user.lastname}"
                          : "Welcome Guest",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isLoggedIn && user != null
                          ? user.email
                          : "Please login to access your profile",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isLoggedIn) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: user?.active == true ? Colors.green : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            user?.active == true ? "Active" : "Inactive",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Quick Stats - Only show if logged in
          if (isLoggedIn) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("Cart", cartCount.toString()),
                  _buildStatItem("Wishlist", wishlistCount.toString()),
                  _buildStatItem("Payments", paymentCount.toString()),
                ],
              ),
            ),
          ] else ...[
            // Login prompt for guests
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.white.withOpacity(0.8),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Login to access all features",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedAppInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D47A1),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "E-Commerce App",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Developed by Khimhengngoun",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "v1.0.0",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, AuthProvider auth) async {
    return showDialog(
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
                          await auth.logout();
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
}