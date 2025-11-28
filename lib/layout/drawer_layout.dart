import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecom/modules/auth/providers/auth_provider.dart';
import 'package:flutter_ecom/modules/cart/provider/cart_provider.dart';
import 'package:flutter_ecom/modules/payment_history/provider/payment_history_provider.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';

import 'drawer_widgets/drawer_header.dart';
import 'drawer_widgets/drawer_sections.dart';
import 'drawer_widgets/app_info.dart';

class DrawerLayout extends StatefulWidget {
  const DrawerLayout({super.key});

  @override
  State<DrawerLayout> createState() => _DrawerLayoutState();
}

class _DrawerLayoutState extends State<DrawerLayout> {
  @override
  void initState() {
    super.initState();
    _refreshPaymentCount();
  }

  void _refreshPaymentCount() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final paymentProvider = context.read<PaymentHistoryProvider>();
      final authProvider = context.read<AuthProvider>();

      if (authProvider.isAuthenticated && !paymentProvider.loading) {
        paymentProvider.refreshCount();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final paymentProvider = Provider.of<PaymentHistoryProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    final isLoggedIn = authProvider.isAuthenticated;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 🔥 ENHANCED HEADER
          DrawerHeaderWidget(
            isLoggedIn: isLoggedIn,
            user: authProvider.user,
            cartCount: cartProvider.badgeCount,
            wishlistCount: wishlistProvider.itemCount,
            paymentCount: paymentProvider.count,
          ),

          Expanded(
            child: DrawerSections(
              isLoggedIn: isLoggedIn,
              cartCount: cartProvider.badgeCount,
              wishlistCount: wishlistProvider.itemCount,
              paymentCount: paymentProvider.count,
              authProvider: authProvider,
              paymentProvider: paymentProvider,
            ),
          ),

          // 🔥 ENHANCED APP INFO
          const AppInfoWidget(),
        ],
      ),
    );
  }
}