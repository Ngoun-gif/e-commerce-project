import 'package:flutter/material.dart';
import 'package:flutter_ecom/theme/app_colors.dart';
import 'package:provider/provider.dart';

import '../providers/wishlist_provider.dart';


class WishlistFilterTabs extends StatefulWidget {
  const WishlistFilterTabs({super.key});

  @override
  State<WishlistFilterTabs> createState() => _WishlistFilterTabsState();
}

class _WishlistFilterTabsState extends State<WishlistFilterTabs> {
  int _selectedIndex = 0;

  final List<String> _filters = ['All', 'Trending', 'Price'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return FilterBtn(
            label: _filters[index],
            selected: _selectedIndex == index,
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              // Implement filter logic here
              _applyFilter(_filters[index]);
            },
          );
        },
      ),
    );
  }

  void _applyFilter(String filter) {
    final provider = context.read<WishlistProvider>();
    // Implement your filter logic here
    switch (filter) {
      case 'Trending':
      // Filter trending items
        break;
      case 'Price':
      // Sort by price
        break;
      default:
      // Show all
        break;
    }
  }
}

class FilterBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const FilterBtn({
    super.key,
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: selected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}