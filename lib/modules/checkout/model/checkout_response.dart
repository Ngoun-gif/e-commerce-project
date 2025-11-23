import 'checkout_items_response.dart';

class CheckoutResponse{
  final int orderId;
  final double totalPrice;
  final String status;
  final String paymentMethod;
  final List<CheckoutItemRes> items;

  CheckoutResponse({
    required this.orderId,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    required this.items,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      orderId: json["orderId"],
      totalPrice: double.tryParse(json["totalPrice"].toString()) ?? 0,
      status: json["status"],
      paymentMethod: json["paymentMethod"],
      items: (json["items"] as List? ?? [])
          .map((e) => CheckoutItemRes.fromJson(e))
          .toList(),
    );
  }
}
