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

    // Sync auth state and load wishlist on first build
    if (_initialLoad) {
      _initialLoad = false;
      _syncAuthAndLoadWishlist();
    }
  }

  void _syncAuthAndLoadWishlist() {
    final authProvider = context.read<AuthProvider>();
    final wishlistProvider = context.read<WishlistProvider>();

    print("🔄 WishlistScreen - Syncing auth state: ${authProvider.isAuthenticated}");

    // Update wishlist provider with current auth state
    wishlistProvider.updateAuthState(authProvider.isAuthenticated);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();

    // Sync auth state whenever it changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (wishlistProvider.isAuthenticated != authProvider.isAuthenticated) {
        print("🔄 WishlistScreen - Auth state changed, resyncing...");
        wishlistProvider.updateAuthState(authProvider.isAuthenticated);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Wishlist"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          if (authProvider.isAuthenticated && wishlistProvider.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                wishlistProvider.loadWishlist();
              },
              tooltip: 'Refresh wishlist',
            ),
        ],
      ),
      body: _buildBody(authProvider, wishlistProvider),
    );
  }

  Widget _buildBody(AuthProvider authProvider, WishlistProvider wishlistProvider) {
    print("🎯 WishlistScreen - Building body. Auth: ${authProvider.isAuthenticated}, Loading: ${wishlistProvider.loading}, Items: ${wishlistProvider.items.length}");

    // Show login prompt if not authenticated
    if (!authProvider.isAuthenticated) {
      print("🚫 WishlistScreen - User not authenticated, showing login prompt");
      return _buildLoginPrompt();
    }

    // Show loading state (only on initial load when items are empty)
    if (wishlistProvider.loading && wishlistProvider.items.isEmpty) {
      print("⏳ WishlistScreen - Showing loading indicator");
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show error state
    if (wishlistProvider.error != null && wishlistProvider.items.isEmpty) {
      print("❌ WishlistScreen - Showing error: ${wishlistProvider.error}");
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              wishlistProvider.error!,
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print("🔄 WishlistScreen - Retry loading wishlist");
                wishlistProvider.loadWishlist();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Show empty state or wishlist content
    if (wishlistProvider.items.isEmpty) {
      print("📭 WishlistScreen - Showing empty view");
      return const WishlistEmptyView();
    } else {
      print("📦 WishlistScreen - Showing ${wishlistProvider.items.length} items");
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
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              "Please Login to View Your Wishlist",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
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
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text("Sign In"),
            ),
          ],
        ),
      ),
    );
  }
}