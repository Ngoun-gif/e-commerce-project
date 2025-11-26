import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/payment_history/screens/payment_history_screen.dart';


class DrawerLayout extends StatelessWidget {
  const DrawerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF0D47A1),   // 💙 Deep Blue Color
            ),
            child: Center(              // ⭐ CENTER the content
              child: Text(
                "E-Shop Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 🔥 PAYMENT HISTORY - Updated with navigation
          ListTile(
            leading: Icon(Icons.payment, color: Color(0xFF0D47A1)), // Changed icon to payment
            title: Text(
              "Payment History",
              style: TextStyle(color: Color(0xFF0D47A1)),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer first
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentHistoryScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.settings, color: Color(0xFF0D47A1)),
            title: Text(
              "Settings",
              style: TextStyle(color: Color(0xFF0D47A1)),
            ),
            onTap: () {
              // Add navigation for Settings
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Color(0xFF0D47A1)),
            title: Text(
              "Logout",
              style: TextStyle(color: Color(0xFF0D47A1)),
            ),
            onTap: () {
              // Add logout functionality
            },
          ),
        ],
      ),
    );
  }
}