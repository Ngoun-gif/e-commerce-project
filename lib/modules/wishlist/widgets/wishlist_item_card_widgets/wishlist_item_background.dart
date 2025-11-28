import 'package:flutter/material.dart';

class WishlistItemBackground extends StatelessWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback onTap;

  const WishlistItemBackground({
    super.key,
    required this.child,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? Colors.blue.shade50
                : Colors.blue.shade50.withOpacity(0.6), // Only blue colors
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.blue.shade100,
              width: 1.6,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}