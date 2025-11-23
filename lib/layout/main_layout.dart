import 'package:flutter/material.dart';
import 'top_nav_bar.dart';
import 'drawer_layout.dart';
import 'bottom_nav_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavBar(),
      drawer: const DrawerLayout(),
      body: child,
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
