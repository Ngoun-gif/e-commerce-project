import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/home/models/product.dart';


class CategoryProductImageWithLoading extends StatefulWidget {
  final ProductModel product;

  const CategoryProductImageWithLoading({super.key, required this.product});

  @override
  State<CategoryProductImageWithLoading> createState() => _CategoryProductImageWithLoadingState();
}

class _CategoryProductImageWithLoadingState extends State<CategoryProductImageWithLoading> {
  late final ImageProvider _imageProvider;

  @override
  void initState() {
    super.initState();
    _imageProvider = NetworkImage(widget.product.image);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Image(
        image: _imageProvider,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _ImageErrorState(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _ImageLoadingState(loadingProgress: loadingProgress);
        },
      ),
    );
  }
}

class _ImageLoadingState extends StatelessWidget {
  final ImageChunkEvent? loadingProgress;

  const _ImageLoadingState({this.loadingProgress});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress?.expectedTotalBytes != null
              ? loadingProgress!.cumulativeBytesLoaded / loadingProgress!.expectedTotalBytes!
              : null,
          color: const Color(0xFF0D47A1),
          backgroundColor: Colors.grey[300],
          strokeWidth: 1.5,
        ),
      ),
    );
  }
}

class _ImageErrorState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey,
              size: 20,
            ),
            SizedBox(height: 2),
            Text(
              'No Image',
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}