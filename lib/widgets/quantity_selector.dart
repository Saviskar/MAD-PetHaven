import 'package:flutter/material.dart';

/// A reusable widget for selecting quantities with increment/decrement buttons.
///
/// Used in cart items and product detail pages.
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int min;
  final int max;
  final bool compact;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.min = 1,
    this.max = 99,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (compact) {
      // Compact style for product detail page
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: quantity > min ? onDecrement : null,
            icon: const Icon(Icons.indeterminate_check_box_outlined),
            tooltip: 'Decrease',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              quantity.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            onPressed: quantity < max ? onIncrement : null,
            icon: const Icon(Icons.add_box_outlined),
            tooltip: 'Increase',
          ),
        ],
      );
    }

    // Bordered style for cart page
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _squareBtn(
            context,
            icon: Icons.indeterminate_check_box,
            onTap: quantity > min ? onDecrement : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantity',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          _squareBtn(
            context,
            icon: Icons.add_box,
            onTap: quantity < max ? onIncrement : null,
          ),
        ],
      ),
    );
  }

  Widget _squareBtn(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        ),
        child: Icon(icon, size: 22, color: onTap == null ? Colors.grey : null),
      ),
    );
  }
}
