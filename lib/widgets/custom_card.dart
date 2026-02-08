import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final double? price;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? discount;

  const CustomCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.price,
    this.onTap,
    this.margin,
    this.width,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode =
        theme.brightness == Brightness.dark; // 👈 detect dark mode

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        margin: margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          // 👇 Adaptive background color
          color: isDarkMode
              ? const Color(0xFF1E1E1E) // dark surface
              : Colors.white,

          borderRadius: BorderRadius.circular(16),

          // 👇 Gentle border only in dark mode for separation
          border: isDarkMode
              ? Border.all(color: Colors.grey.withValues(alpha: 0.3))
              : null,

          // 👇 Light shadow only in light mode
          boxShadow: isDarkMode
              ? []
              : [
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
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: _getAspectRatio(context),
                    child: imagePath.startsWith('http')
                        ? Image.network(
                            imagePath,
                            fit: BoxFit.cover,
                            cacheWidth: 500, // Optimize memory usage
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : Image.asset(imagePath, fit: BoxFit.cover),
                  ),
                ),
                if (discount != null && discount! > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${discount!.toStringAsFixed(0)}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
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
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isDarkMode
                      ? Colors
                            .white // 👈 readable on dark bg
                      : Colors.black87,
                ),
              ),
            ),

            // Price
            // Price
            if (price != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: (discount != null && discount! > 0)
                    ? Row(
                        children: [
                          Text(
                            'Rs. ${price!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: isDarkMode
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Rs. ${(price! * (1 - discount! / 100)).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.redAccent.shade100
                                  : Colors.red.shade700,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Rs. ${price!.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade700,
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
