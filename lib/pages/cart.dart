import 'package:flutter/material.dart';
import '../data/cart_manager.dart';
import '../data/product_repository.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final cart = CartManager();
  final products = ProductRepository();

  @override
  void initState() {
    super.initState();
    cart.load().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: items.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final product = products.byId(item.productId);
                if (product == null) return const SizedBox.shrink();

                return ListTile(
                  leading: Image.asset(
                    product.imageAsset,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(product.name),
                  subtitle: Text('Rs. ${product.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.indeterminate_check_box),
                        onPressed: () async {
                          await cart.update(product.id, item.quantity - 1);
                          setState(() {});
                        },
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add_box),
                        onPressed: () async {
                          await cart.update(product.id, item.quantity + 1);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
