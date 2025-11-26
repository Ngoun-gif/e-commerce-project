import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/payment_history/models/payment_history_model.dart';
import 'package:flutter_ecom/modules/payment_history/provider/payment_history_provider.dart';
import 'package:flutter_ecom/modules/payment_history/widgets/empty_state_widget.dart';
import 'package:flutter_ecom/modules/payment_history/widgets/payment_card.dart';
import 'package:provider/provider.dart';
import '../widgets/payment_summary_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    print("🔄 PaymentHistoryScreen initialized");

    // Fetch initial payments when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("🚀 Starting all payments fetch...");
      await context.read<PaymentHistoryProvider>().fetchAllPayments();
    });

    // Setup scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Check if we've reached the bottom of the list
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100 && // Load more when 100px from bottom
        !_isLoadingMore) {
      _loadMorePayments();
    }
  }

  Future<void> _loadMorePayments() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final provider = context.read<PaymentHistoryProvider>();
    // You can implement pagination logic here if your backend supports it
    // For now, we'll just simulate loading more
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Payments",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Consumer<PaymentHistoryProvider>(
        builder: (context, paymentHistoryProvider, child) {
          print("🔄 Building UI - Loading: ${paymentHistoryProvider.loading}, Error: ${paymentHistoryProvider.error}, Payments: ${paymentHistoryProvider.payments.length}");

          // Show loading
          if (paymentHistoryProvider.loading && paymentHistoryProvider.payments.isEmpty) {
            return const LoadingWidget();
          }

          // Show error
          if (paymentHistoryProvider.error != null && paymentHistoryProvider.payments.isEmpty) {
            return PaymentErrorWidget(
              error: paymentHistoryProvider.error!,
              onRetry: () => paymentHistoryProvider.fetchAllPayments(),
            );
          }

          // Show empty state if no payments
          if (paymentHistoryProvider.payments.isEmpty) {
            return const EmptyStateWidget();
          }

          // Show payment list
          return _buildPaymentList(
            paymentHistoryProvider.payments,
            paymentHistoryProvider,
          );
        },
      ),
      floatingActionButton: Consumer<PaymentHistoryProvider>(
        builder: (context, paymentHistoryProvider, child) {
          return FloatingActionButton(
            onPressed: () {
              print("🔄 Manual refresh triggered");
              paymentHistoryProvider.refresh();
            },
            backgroundColor: const Color(0xFF0D47A1),
            foregroundColor: Colors.white,
            child: const Icon(Icons.refresh),
          );
        },
      ),
    );
  }

  Widget _buildPaymentList(List<PaymentHistoryModel> payments, PaymentHistoryProvider provider) {
    // Sort by latest first
    payments.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      children: [
        // Summary Card
        PaymentSummaryCard(payments: payments),

        // Payments List
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              // Use ScrollUpdateNotification for better performance
              if (scrollNotification is ScrollUpdateNotification) {
                final maxScroll = _scrollController.position.maxScrollExtent;
                final currentScroll = _scrollController.position.pixels;

                // Load more when we're 100px from the bottom and not currently loading
                if (maxScroll - currentScroll <= 100 && !_isLoadingMore) {
                  _loadMorePayments();
                }
              }
              return false;
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: payments.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == payments.length) {
                  return _buildLoadingMoreIndicator();
                }
                final payment = payments[index];
                return PaymentCard(
                  payment: payment,
                  index: index + 1,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D47A1)),
            ),
            SizedBox(height: 8),
            Text(
              "Loading more payments...",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF0D47A1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}