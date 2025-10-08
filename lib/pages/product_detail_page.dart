// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:pet_haven/data/cart_manager.dart';
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
  String? selectedWeight;
  String? selectedColor;

  @override
  Widget build(BuildContext context) {
    final product = ProductRepository().byId(widget.productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Product not found')),
      );
    }

    selectedWeight ??= (product.quantities?.isNotEmpty ?? false)
        ? product.quantities!.first
        : null;

    selectedColor ??= (product.colors?.isNotEmpty ?? false)
        ? product.colors!.first
        : null;

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    Widget productImage({EdgeInsetsGeometry? margin}) {
      return Container(
        margin: margin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: isLandscape ? 1 : 1.4,
            child: Image.asset(product.imageAsset, fit: BoxFit.cover),
          ),
        ),
      );
    }

    Widget detailsColumn() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          // ----- Variant Quantity radios (only if present) -----
          if (product.quantities != null && product.quantities!.isNotEmpty) ...[
            Text(
              'Quantity / Size',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            ...product.quantities!.map((opt) {
              return RadioListTile<String>(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(opt),
                activeColor: AppColors.primary,
                value: opt,
                groupValue: selectedWeight,
                onChanged: (value) => setState(() => selectedWeight = value),
              );
            }),
            const SizedBox(height: 8),
          ],

          // ----- Color radios (only if present) -----
          if (product.colors != null && product.colors!.isNotEmpty) ...[
            Text(
              'Color',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            ...product.colors!.map((opt) {
              return RadioListTile<String>(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(opt),
                activeColor: AppColors.primary,
                value: opt,
                groupValue: selectedColor,
                onChanged: (value) => setState(() => selectedColor = value),
              );
            }),
            const SizedBox(height: 8),
          ],

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
                  if (quantity > 1) setState(() => quantity--);
                },
                icon: const Icon(Icons.indeterminate_check_box_outlined),
                tooltip: 'Decrease',
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
                  if (quantity < 10) setState(() => quantity++);
                },
                icon: const Icon(Icons.add_box_outlined),
                tooltip: 'Increase',
              ),
            ],
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () async {
              await CartManager().add(product.id, quantity: quantity);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added $quantity x ${product.name}')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Add to Cart'),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (isLandscape && constraints.maxWidth > 600) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // left column
                  Expanded(flex: 5, child: productImage()),
                  const SizedBox(width: 24),
                  // right column
                  Expanded(
                    flex: 7,
                    child: SingleChildScrollView(child: detailsColumn()),
                  ),
                ],
              );
            }

            return ListView(
              children: [
                productImage(),
                const SizedBox(height: 16),
                detailsColumn(),
              ],
            );
          },
        ),
      ),
    );
  }
}
