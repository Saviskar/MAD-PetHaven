import 'package:flutter/material.dart';
import 'package:pet_haven/controllers/product_controller.dart';
import 'package:pet_haven/models/product.dart';
import 'package:pet_haven/widgets/bread_crumb.dart';
import 'package:pet_haven/widgets/custom_app_bar.dart';
import 'package:pet_haven/widgets/input_field.dart';
import 'package:pet_haven/widgets/custom_card.dart';
import 'package:pet_haven/views/product_detail_page.dart';
import 'package:provider/provider.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  String _selectedCategory = 'All Products';
  String _search = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch products when entering the shop if not already loaded or stale
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductController>().refresh();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final controller = context.read<ProductController>();
    if (controller.isFetchingMore || controller.isLoading) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.fetchNextPage();
    }
  }

  bool _matchesCategory(Product p) =>
      _selectedCategory == 'All Products' || p.category == _selectedCategory;

  List<Product> _filteredProducts(List<Product> all) {
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
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: 'Pet Haven'),
      body: Consumer<ProductController>(
        builder: (context, controller, child) {
          final categories = [
            ('All Products', Icons.apps),
            ...controller.categories.map((c) {
              final n = c.name.toLowerCase();
              IconData i = Icons.category;
              if (n.contains('food')) {
                i = Icons.restaurant;
              } else if (n.contains('toy')) {
                i = Icons.sports_esports;
              } else if (n.contains('groom')) {
                i = Icons.cut;
              } else if (n.contains('access')) {
                i = Icons.shopping_bag;
              } else if (n.contains('cloth') || n.contains('rain')) {
                i = Icons.checkroom;
              } else if (n.contains('health') || n.contains('med')) {
                i = Icons.medical_services;
              } else if (n.contains('bed')) {
                i = Icons.bed;
              }
              return (c.name, i);
            }),
          ];

          if (controller.isLoading && controller.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error != null && controller.products.isEmpty) {
            return Center(child: Text('Error: ${controller.error}'));
          }

          final products = _filteredProducts(controller.products);

          return LayoutBuilder(
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

              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(20.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Search
                        InputField(
                          hintText: 'Search for pet supplies',
                          onChanged: (val) => setState(() => _search = val),
                        ),

                        const SizedBox(height: 10),

                        // Categories Row
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final (title, icon) in categories) ...[
                                BreadCrumb(
                                  title: title,
                                  icon: icon,
                                  selected: _selectedCategory == title,
                                  onTap: () =>
                                      setState(() => _selectedCategory = title),
                                ),
                                const SizedBox(width: 10),
                              ],
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
                      ]),
                    ),
                  ),

                  // Responsive Products Grid
                  products.isEmpty
                      ? const SliverToBoxAdapter(
                          child: Center(child: Text("No products found")),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: cols,
                                  mainAxisSpacing: spacing,
                                  crossAxisSpacing: spacing,
                                  childAspectRatio: 0.82,
                                ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final product = products[index];

                              // Check if this product is in promoted lists to get discount info
                              // because the main products API might not return discount fields
                              final promoted = controller.promotedProducts
                                  .firstWhere(
                                    (p) => p.id == product.id,
                                    orElse: () => product,
                                  );
                              final discount =
                                  promoted.discount ?? product.discount;

                              return CustomCard(
                                title: product.name,
                                imagePath: product.imageUrl,
                                price: product.price,
                                discount: discount,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailPage(
                                        productId: product.id,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }, childCount: products.length),
                          ),
                        ),

                  // Loading Indicator at bottom
                  if (controller.isFetchingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    )
                  else
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
