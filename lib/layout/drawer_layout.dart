import 'package:flutter/material.dart';

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

          ListTile(
            leading: Icon(Icons.history, color: Color(0xFF0D47A1)),
            title: Text(
              "Order History",
              style: TextStyle(color: Color(0xFF0D47A1)),
            ),
            onTap: () {
              // Add navigation for Order History
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