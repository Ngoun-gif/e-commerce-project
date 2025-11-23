import 'package:flutter/material.dart';
import 'bottom_bar_layout.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: BottomBarLayout.currentIndex,
      selectedItemColor: const Color(0xFF0D47A1),   // ⭐ deep blue
      unselectedItemColor: Colors.grey,

      onTap: (i) {
        setState(() => BottomBarLayout.currentIndex = i);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomBarLayout()),
        );
      },

      type: BottomNavigationBarType.fixed,

      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined), label: "Category"),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border), label: "Wishlist"),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }
}
