import 'package:flutter/material.dart';
import 'package:pet_haven/data/cart_manager.dart';
import 'package:pet_haven/data/product_repository.dart';
import 'package:pet_haven/components/wide_button.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final cart = CartManager();
  final products = ProductRepository();
  static const double _shippingFlat = 20.00;

  @override
  void initState() {
    super.initState();
    cart.load().then((_) => setState(() {}));
  }

  String _price(double v) => 'Rs. ${v.toStringAsFixed(2)}';

  double get _subtotal {
    double sum = 0;
    for (final item in cart.items) {
      final p = products.byId(item.productId);
      if (p != null) sum += p.price * item.quantity;
    }
    return sum;
  }

  double get _shipping => cart.items.isEmpty ? 0 : _shippingFlat;
  double get _total => _subtotal + _shipping;

  @override
  Widget build(BuildContext context) {
    final items = cart.items;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(
                child: Text(
                  'Your cart is empty',
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              ),
            )
          else
            ...List.generate(items.length, (index) {
              final item = items[index];
              final product = products.byId(item.productId);
              if (product == null) return const SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        product.imageAsset,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _price(product.price),
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.red.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _QtyBox(
                      quantity: item.quantity,
                      onDec: () async {
                        final next = item.quantity - 1;
                        await cart.update(product.id, next);
                        setState(() {});
                      },
                      onInc: () async {
                        final next = item.quantity + 1;
                        await cart.update(product.id, next);
                        setState(() {});
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Remove',
                      icon: Icon(Icons.delete, color: Colors.red.shade600),
                      onPressed: () async {
                        await cart.update(product.id, 0);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              );
            }),

          if (items.isNotEmpty) ...[
            const SizedBox(height: 8),

            // Totals summary box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _kvRow('Subtotal', _price(_subtotal), scheme),
                  const SizedBox(height: 8),
                  _kvRow('Shipping', _price(_shipping), scheme),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _price(_total),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Clear Cart (Styled Dialog)
            WideButton(
              placeholder: 'Clear Cart',
              backgroundColor: Colors.red.shade400,
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => Theme(
                    data: Theme.of(context).copyWith(
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                      ),
                      dialogTheme: DialogThemeData(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        'Clear Cart',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                        'Are you sure you want to remove all items from your cart?',
                        style: TextStyle(fontSize: 15),
                      ),
                      actionsPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                if (confirmed == true) {
                  await cart.clear();
                  if (mounted) setState(() {});
                }
              },
            ),

            const SizedBox(height: 12),

            // Checkout
            WideButton(
              placeholder: 'Checkout',
              backgroundColor: Colors.red.shade600,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Checkout is a demo action')),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _kvRow(String k, String v, ColorScheme scheme) {
    return Row(
      children: [
        Text(
          k,
          style: TextStyle(
            color: scheme.onSurface.withValues(alpha: 0.8),
            fontSize: 14.5,
          ),
        ),
        const Spacer(),
        Text(
          v,
          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// Quantity control
class _QtyBox extends StatelessWidget {
  final int quantity;
  final VoidCallback onDec;
  final VoidCallback onInc;

  const _QtyBox({
    required this.quantity,
    required this.onDec,
    required this.onInc,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
            onTap: onDec,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantity',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          _squareBtn(context, icon: Icons.add_box, onTap: onInc),
        ],
      ),
    );
  }

  Widget _squareBtn(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
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
        child: Icon(icon, size: 22),
      ),
    );
  }
}
