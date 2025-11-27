import 'package:flutter/material.dart';
import 'top_nav_bar.dart';
import 'drawer_layout.dart';
import 'bottom_nav_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final void Function(int) onTabChange;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavBar(),
      drawer: const DrawerLayout(),
      body: child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTabChange: onTabChange,
      ),
    );
  }
}
