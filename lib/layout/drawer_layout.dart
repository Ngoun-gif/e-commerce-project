import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/user/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecom/modules/payment_history/screens/payment_history_screen.dart';
import 'package:flutter_ecom/modules/auth/providers/auth_provider.dart';
import 'package:flutter_ecom/routers/app_routes.dart';

class DrawerLayout extends StatelessWidget {
  const DrawerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoggedIn = authProvider.isAuthenticated;
    final user = authProvider.user;

    return Drawer(
      child: Column(
        children: [
          // 🔥 DYNAMIC HEADER - Shows user info if logged in
          _buildDrawerHeader(context, isLoggedIn, user),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // 🔥 PAYMENT HISTORY - Only show if logged in
                if (isLoggedIn) ...[
                  ListTile(
                    leading: Icon(Icons.payment, color: Color(0xFF0D47A1)),
                    title: Text(
                      "Payments History",
                      style: TextStyle(color: Color(0xFF0D47A1)),
                    ),
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
                  const Divider(height: 1),
                ],

                // 🔥 DYNAMIC AUTH ACTION - Login/Logout
                ListTile(
                  leading: Icon(
                    isLoggedIn ? Icons.logout : Icons.login,
                    color: Color(0xFF0D47A1),
                  ),
                  title: Text(
                    isLoggedIn ? "Logout" : "Login",
                    style: TextStyle(color: Color(0xFF0D47A1)),
                  ),
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
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.person_add, color: Color(0xFF0D47A1)),
                    title: Text(
                      "Create Account",
                      style: TextStyle(color: Color(0xFF0D47A1)),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, bool isLoggedIn, UserModel? user) {
    return UserAccountsDrawerHeader(
      accountName: Text(
        isLoggedIn && user != null
            ? "${user.firstname} ${user.lastname}"
            : "Welcome Guest",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      accountEmail: Text(
        isLoggedIn && user != null
            ? user.email
            : "Please login to access your profile",
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.person,
          color: Color(0xFF0D47A1),
          size: 40,
        ),
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0D47A1),
      ),
      otherAccountsPictures: isLoggedIn ? [
        // Status indicator
        CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: user?.active == true ? Colors.green : Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ] : null,
    );
  }

  // Alternative: More detailed header with user info
  Widget _buildDetailedDrawerHeader(BuildContext context, bool isLoggedIn, UserModel? user) {
    return Container(
      color: const Color(0xFF0D47A1),
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar and basic info
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Color(0xFF0D47A1),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
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
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isLoggedIn && user != null
                          ? user.email
                          : "Please login to access your profile",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    if (isLoggedIn && user != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: user.active ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          user.active ? "Active" : "Inactive",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          if (!isLoggedIn) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF0D47A1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Login"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Register"),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, AuthProvider auth) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text("Logout"),
            ],
          ),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await auth.logout();
                Navigator.pushReplacementNamed(context, AppRoutes.main);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}