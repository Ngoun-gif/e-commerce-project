import 'package:flutter/material.dart';
import 'main_layout.dart';

import '../modules/home/screens/home_screen.dart';
import '../modules/category/screens/category_screen.dart';
import '../modules/wishlist/screens/wishlist_screen.dart';
import '../modules/cart/screens/cart_screen.dart';
import '../modules/profile/screens/profile_screen.dart';

class BottomBarLayout extends StatefulWidget {
  static int currentIndex = 0;

  /// 🔥 Expose function to change tab globally
  static void Function(int index)? changeTab;

  const BottomBarLayout({super.key});

  @override
  State<BottomBarLayout> createState() => _BottomBarLayoutState();
}

class _BottomBarLayoutState extends State<BottomBarLayout> {
  static final screens = const [
    HomeScreen(),
    CategoryScreen(),
    WishlistScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    /// Register global tab function
    BottomBarLayout.changeTab = (int index) {
      setState(() {
        BottomBarLayout.currentIndex = index;
      });
    };
  }

  @override
  void dispose() {
    /// Clean up static
    BottomBarLayout.changeTab = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: screens[BottomBarLayout.currentIndex],
    );
  }
}
