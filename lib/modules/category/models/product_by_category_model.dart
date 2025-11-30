// product_by_category_model.dart
import 'package:flutter_ecom/config/api_config.dart';

class ProductByCategoryModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final bool outOfStock;
  final int stockQuantity;

  ProductByCategoryModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.outOfStock,
    required this.stockQuantity,
  });

  // Add the missing getter
  String get formattedPrice {
    return '\$${price.toStringAsFixed(2)}';
  }

  // Other computed properties for backward compatibility
  String get name => title;
  bool get inStock => !outOfStock;

  // Note: categoryId is not available from API directly
  // You'll need to handle this differently

  factory ProductByCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductByCategoryModel(
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? '',
      price: (json['price'] is double)
          ? json['price']
          : (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      image: ApiConfig.fixImage(json['image']?.toString() ?? ''),
      outOfStock: (json['outOfStock'] is bool)
          ? json['outOfStock']
          : (json['outOfStock'] is String)
          ? json['outOfStock'] == 'true'
          : false,
      stockQuantity: (json['stockQuantity'] is int)
          ? json['stockQuantity']
          : int.tryParse(json['stockQuantity'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'outOfStock': outOfStock,
      'stockQuantity': stockQuantity,
    };
  }
}