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

    print("🔄 WishlistScreen - Syncing auth state: ${authProvider.isAuthenticated}");
    wishlistProvider.updateAuthState(authProvider.isAuthenticated);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (wishlistProvider.isAuthenticated != authProvider.isAuthenticated) {
        print("🔄 WishlistScreen - Auth state changed, resyncing...");
        wishlistProvider.updateAuthState(authProvider.isAuthenticated);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "My Wishlist",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
        centerTitle: true,
        actions: [
          if (authProvider.isAuthenticated && wishlistProvider.items.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: AppColors.primary,
              ),
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

    if (!authProvider.isAuthenticated) {
      print("🚫 WishlistScreen - User not authenticated, showing login prompt");
      return _buildLoginPrompt();
    }

    if (wishlistProvider.loading && wishlistProvider.items.isEmpty) {
      print("⏳ WishlistScreen - Showing loading indicator");
      return _buildLoadingState();
    }

    if (wishlistProvider.error != null && wishlistProvider.items.isEmpty) {
      print("❌ WishlistScreen - Showing error: ${wishlistProvider.error}");
      return _buildErrorState(wishlistProvider);
    }

    if (wishlistProvider.items.isEmpty) {
      print("📭 WishlistScreen - Showing empty view");
      return const WishlistEmptyView();
    } else {
      print("📦 WishlistScreen - Showing ${wishlistProvider.items.length} items");
      return const WishlistListView();
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Loading your wishlist...",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(WishlistProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 40,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Oops! Something went wrong",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            provider.error!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  provider.loadWishlist();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Try Again'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "Your Wishlist Awaits",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            "Sign in to save and manage your favorite items",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                "Sign In to Continue",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Continue Shopping",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}