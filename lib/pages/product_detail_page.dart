import 'package:flutter/material.dart';
import 'package:pet_haven/data/product_repository.dart';
import 'package:pet_haven/theme/color.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = ProductRepository().byId(widget.productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Product not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AspectRatio(
            aspectRatio: 1.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(product.imageAsset, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            product.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 6),
          Text(
            'Rs. ${product.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 10),
          const Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(product.description, style: const TextStyle(height: 1.4)),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  if (quantity > 1) {
                    setState(() => quantity--);
                  }
                },
                icon: const Icon(Icons.indeterminate_check_box_outlined),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  quantity.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (quantity < 10) {
                    // optional max limit
                    setState(() => quantity++);
                  }
                },
                icon: const Icon(Icons.add_box_outlined),
              ),
            ],
          ),

          const SizedBox(height: 24),

          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added $quantity × ${product.name} to cart'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
