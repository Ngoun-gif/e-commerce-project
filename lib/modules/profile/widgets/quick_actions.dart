import 'package:flutter/material.dart';
import 'package:flutter_ecom/theme/app_colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.flash_on_outlined,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionChip(
                context: context,
                icon: Icons.edit_outlined,
                label: "Edit Profile",
                onTap: () => _editProfile(context),
              ),
              _buildActionChip(
                context: context,
                icon: Icons.history_outlined,
                label: "Order History",
                onTap: () => _viewOrderHistory(context),
              ),
              _buildActionChip(
                context: context,
                icon: Icons.favorite_outline,
                label: "Wishlist",
                onTap: () => _viewWishlist(context),
              ),
              _buildActionChip(
                context: context,
                icon: Icons.help_outline,
                label: "Help Center",
                onTap: () => _showHelp(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[700] : Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Edit profile feature coming soon!")),
    );
  }

  void _viewOrderHistory(BuildContext context) {
    // Navigator.pushNamed(context, '/orders');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Order history coming soon!")),
    );
  }

  void _viewWishlist(BuildContext context) {
    Navigator.pushNamed(context, '/wishlist');
  }

  void _showHelp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Help center coming soon!")),
    );
  }
}