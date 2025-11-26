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
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeWishlist();
  }

  void _initializeWishlist() {
    Future.microtask(() {
      final authProvider = context.read<AuthProvider>();
      final wishlistProvider = context.read<WishlistProvider>();

      // Sync authentication state with wishlist provider
      wishlistProvider.setAuthenticated(authProvider.isAuthenticated, notify: false);

      // Load wishlist only if authenticated
      if (authProvider.isAuthenticated) {
        wishlistProvider.loadWishlist();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _syncAuthState();
    }
  }

  void _syncAuthState() {
    Future.microtask(() {
      final authProvider = context.read<AuthProvider>();
      final wishlistProvider = context.read<WishlistProvider>();

      if (wishlistProvider.isAuthenticated != authProvider.isAuthenticated) {
        wishlistProvider.setAuthenticated(authProvider.isAuthenticated, notify: false);
        if (authProvider.isAuthenticated) {
          wishlistProvider.loadWishlist();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Wishlist"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: _buildBody(authProvider, wishlistProvider),
    );
  }

  Widget _buildBody(AuthProvider authProvider, WishlistProvider wishlistProvider) {
    // Show login prompt if not authenticated
    if (!authProvider.isAuthenticated) {
      return _buildLoginPrompt();
    }

    // Show loading state
    if (wishlistProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error state
    if (wishlistProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(wishlistProvider.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => wishlistProvider.loadWishlist(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Show empty state or wishlist content
    return wishlistProvider.items.isEmpty
        ? const WishlistEmptyView()
        : const WishlistListView();
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