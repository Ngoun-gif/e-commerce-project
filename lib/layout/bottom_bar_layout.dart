import 'package:flutter/material.dart';
import 'main_layout.dart';

import '../modules/home/screens/home_screen.dart';
import '../modules/category/screens/category_screen.dart';
import '../modules/wishlist/screens/wishlist_screen.dart';
import '../modules/cart/screens/cart_screen.dart';
import '../modules/profile/screens/profile_screen.dart';

class BottomBarLayout extends StatefulWidget {
  final int initialIndex;

  const BottomBarLayout({super.key, this.initialIndex = 0});

  @override
  State<BottomBarLayout> createState() => _BottomBarLayoutState();
}

class _BottomBarLayoutState extends State<BottomBarLayout> {
  late int _currentIndex;

  final List<Widget> screens = const [
    HomeScreen(),
    CategoryScreen(),
    WishlistScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _changeTab(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: _currentIndex,
      onTabChange: _changeTab,
      child: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
    );
  }
}
