import 'checkout_items_response.dart';

class OrderResponse {
  final int orderId;
  final double totalPrice;
  final String status;
  final String paymentMethod;
  final List<OrderItemRes> items;

  OrderResponse({
    required this.orderId,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    required this.items,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orderId: json["orderId"],
      totalPrice: double.tryParse(json["totalPrice"].toString()) ?? 0,
      status: json["status"],
      paymentMethod: json["paymentMethod"],
      items: (json["items"] as List? ?? [])
          .map((e) => OrderItemRes.fromJson(e))
          .toList(),
    );
  }
}
