import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final double? price;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final double? width;

  const CustomCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.price,
    this.onTap,
    this.margin,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        margin: margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: _getAspectRatio(context),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),

            // Price
            if (price != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Rs. ${price!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

double _getAspectRatio(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width < 600) {
    return 1.2;
  } else if (width >= 600 && width < 900) {
    return 1.05;
  } else if (width > 900 && width < 1000) {
    return 1.1;
  } else if (width > 1200) {
    return 0.95;
  } else {
    return 1;
  }
}
