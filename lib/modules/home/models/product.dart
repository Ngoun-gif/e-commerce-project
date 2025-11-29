import '../../../config/api_config.dart';

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  final bool outOfStock;
  final int stockQuantity;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,

    required this.outOfStock,
    required this.stockQuantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: ApiConfig.fixImage(json['image']),
      outOfStock: json['outOfStock'],
      stockQuantity: json['stockQuantity'],
    );
  }
}
