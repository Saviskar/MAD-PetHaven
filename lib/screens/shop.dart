import 'package:flutter/material.dart';
import 'package:pet_haven/widgets/bread_crumb.dart';
import 'package:pet_haven/widgets/custom_app_bar.dart';
import 'package:pet_haven/widgets/input_field.dart';
import 'package:pet_haven/widgets/custom_card.dart';
import 'package:pet_haven/data/product.dart';
import 'package:pet_haven/data/product_repository.dart';
import 'package:pet_haven/screens/product_detail_page.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final _repo = ProductRepository();
  String _selectedCategory = 'All Products';
  String _search = '';

  bool _matchesCategory(Product p) =>
      _selectedCategory == 'All Products' || p.category == _selectedCategory;

  List<Product> _filteredProducts() {
    final all = _repo.all();
    final q = _search.trim().toLowerCase();
    return all.where((p) {
      final byCat = _matchesCategory(p);
      final bySearch =
          q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          (p.description.toLowerCase().contains(q));
      return byCat && bySearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts();

    return Scaffold(
      appBar: CustomAppBar(appBarTitle: 'Pet Haven'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          // Responsive column count by width
          int cols;
          if (width >= 1200) {
            cols = 5;
          } else if (width >= 900) {
            cols = 4;
          } else if (width >= 600) {
            cols = 3;
          } else {
            cols = 2;
          }

          final spacing = width >= 900 ? 16.0 : 12.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search
                InputField(
                  hintText: 'Search for pet supplies',
                  onChanged: (val) => setState(() => _search = val),
                ),

                const SizedBox(height: 10),

                // Categories Row (functional now)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _crumb('All Products', Icons.apps),
                      const SizedBox(width: 10),
                      _crumb('Accessories', Icons.shopping_bag),
                      const SizedBox(width: 10),
                      _crumb('Food', Icons.restaurant),
                      const SizedBox(width: 10),
                      _crumb('Grooming', Icons.cut),
                      const SizedBox(width: 10),
                      _crumb('Toys', Icons.sports_esports),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  _selectedCategory,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 12),

                // Responsive Products Grid
                GridView.builder(
                  itemCount: products.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return CustomCard(
                      title: product.name,
                      imagePath: product.imageAsset,
                      price: product.price,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailPage(productId: product.id),
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _crumb(String title, IconData icon) {
    return BreadCrumb(
      title: title,
      icon: icon,
      selected: _selectedCategory == title,
      onTap: () => setState(() => _selectedCategory = title),
    );
  }
}
