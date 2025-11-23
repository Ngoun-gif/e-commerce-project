// lib/modules/cart/screens/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import '../widgets/cart_body.dart';
import '../widgets/cart_bottom_total.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CartProvider>().loadCart());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        actions: [
          if (!provider.isEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: provider.isCartLoading || provider.isMutating
                  ? null
                  : () => _showClearCartDialog(context),
            ),
        ],
      ),

      // BODY
      body: provider.isCartLoading
          ? const Center(child: CircularProgressIndicator())
          : CartBody(provider: provider),

      // BOTTOM
      bottomNavigationBar: provider.isCartLoading
          ? null
          : CartBottomTotal(provider: provider),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear Cart?"),
        content: const Text("Are you sure you want to remove all items?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartProvider>().clear();
            },
            child: const Text(
              "Clear",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
