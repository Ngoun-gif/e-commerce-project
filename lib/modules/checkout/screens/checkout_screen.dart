// lib/modules/order/screens/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/checkout/model/checkout_response.dart';
import 'package:flutter_ecom/modules/checkout/provider/checkout_provider.dart';
import 'package:flutter_ecom/routers/app_routes.dart';
import 'package:provider/provider.dart';

import '../../cart/provider/cart_provider.dart';

import '../widgets/payment_method_picker.dart';
import '../widgets/checkout_item_tile.dart';
import '../widgets/checkout_bottom.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = "CARD"; // default

  @override
  void initState() {
    super.initState();
    // Clear old errors when entering checkout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().clearError();
    });
  }

  Future<void> _handleCheckout() async {
    final orderProvider = context.read<OrderProvider>();
    final cartProvider = context.read<CartProvider>();

    orderProvider.clearError();

    await orderProvider.checkout(_selectedPaymentMethod);

    if (orderProvider.error == null && orderProvider.lastOrder != null) {
      // clear local cart UI but NOT backend (backend should do stock logic)
      cartProvider.clearError();

      // Go to payment screen
      Navigator.pushNamed(
        context,
        AppRoutes.payment,
        arguments: {
          'orderId': orderProvider.lastOrder!.orderId,
          'method': orderProvider.lastOrder!.paymentMethod,
        },
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Checkout failed: ${orderProvider.error}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  void _showSuccessDialog(CheckoutResponse order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text("Order Placed!"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your order has been placed successfully."),
            const SizedBox(height: 12),
            Text("Order #: ${order.orderId}"),
            Text("Total: \$${order.totalPrice.toStringAsFixed(2)}"),
            Text("Status: ${order.status}"),
            Text("Payment: ${order.paymentMethod}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text("Continue Shopping"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final orderProvider = context.watch<OrderProvider>();

    if (cartProvider.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Checkout"),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            "Your cart is empty",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ------------------------------
                // ORDER SUMMARY
                // ------------------------------
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.shopping_bag, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              "Order Summary",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ...cartProvider.cart!.items.map(
                              (item) => Column(
                            children: [
                              CheckoutItemTile(item: item),
                              if (item != cartProvider.cart!.items.last)
                                const Divider(),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Amount",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "\$${cartProvider.cart!.totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),
                        Text(
                          "${cartProvider.cart!.items.length} item(s)",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ------------------------------
                // PAYMENT METHOD
                // ------------------------------
                PaymentMethodPicker(
                  selectedMethod: _selectedPaymentMethod,
                  onMethodSelected: (method) {
                    setState(() => _selectedPaymentMethod = method);
                  },
                ),

                if (orderProvider.error != null)
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            orderProvider.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // ------------------------------
          // BOTTOM BAR
          // ------------------------------
          CheckoutBottom(
            total: cartProvider.cart?.totalPrice ?? 0,
            isLoading: orderProvider.loading,
            onCheckout: _handleCheckout,
          ),
        ],
      ),
    );
  }
}
