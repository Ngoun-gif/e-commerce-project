import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/auth/providers/auth_provider.dart';
import 'package:flutter_ecom/theme/app_colors.dart';
import 'package:provider/provider.dart';

import '../providers/wishlist_provider.dart';
import '../widgets/wishlist_empty_view.dart';
import '../widgets/wishlist_list_view.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool _initialLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialLoad) {
      _initialLoad = false;
      _syncAuthAndLoadWishlist();
    }
  }

  void _syncAuthAndLoadWishlist() {
    final authProvider = context.read<AuthProvider>();
    final wishlistProvider = context.read<WishlistProvider>();
    wishlistProvider.updateAuthState(authProvider.isAuthenticated);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (wishlistProvider.isAuthenticated != authProvider.isAuthenticated) {
        wishlistProvider.updateAuthState(authProvider.isAuthenticated);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              "Wishlist",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            if (authProvider.isAuthenticated && wishlistProvider.items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColorsPrimary.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${wishlistProvider.items.length}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColorsPrimary.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          if (authProvider.isAuthenticated && wishlistProvider.items.isNotEmpty)
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200.withOpacity(.4),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.black87,
                ),
                onPressed: () {
                  wishlistProvider.loadWishlist();
                },
                tooltip: 'Refresh wishlist',
              ),
            ),
        ],
      ),
      body: _buildBody(authProvider, wishlistProvider),
    );
  }

  Widget _buildBody(AuthProvider authProvider, WishlistProvider wishlistProvider) {
    if (!authProvider.isAuthenticated) {
      return _buildLoginPrompt();
    }

    if (wishlistProvider.loading && wishlistProvider.items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (wishlistProvider.error != null && wishlistProvider.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.red.shade50,
                border: Border.all(
                  color: Colors.red.shade100,
                  width: 1.6,
                ),
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              wishlistProvider.error!,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColorsPrimary.primary,
              ),
              child: TextButton(
                onPressed: () {
                  wishlistProvider.loadWishlist();
                },
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (wishlistProvider.items.isEmpty) {
      return const WishlistEmptyView();
    } else {
      return const WishlistListView();
    }
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade50,
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1.6,
                ),
              ),
              child: Icon(
                Icons.favorite_border,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Please Login to View Your Wishlist",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "Sign in to save and view your favorite items",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 28),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColorsPrimary.primary,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}