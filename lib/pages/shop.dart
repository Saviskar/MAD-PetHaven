import 'package:flutter/material.dart';
import 'package:pet_haven/components/bread_crumb.dart';
import 'package:pet_haven/components/custom_app_bar.dart';
import 'package:pet_haven/components/input_field.dart';
import 'package:pet_haven/components/custom_card.dart';
import 'package:pet_haven/data/product_repository.dart';
import 'package:pet_haven/pages/product_detail_page.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    final products = ProductRepository().all();

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

          // Spacing scales a touch with width (subtle polish)
          final spacing = width >= 900 ? 16.0 : 12.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputField(hintText: 'Search for pet supplies'),

                // Categories Row (kept as horizontal scroll like your Home page)
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      BreadCrumb(title: 'All Products', icon: Icons.apps),
                      SizedBox(width: 10),
                      BreadCrumb(
                        title: 'Accessories',
                        icon: Icons.shopping_bag,
                      ),
                      SizedBox(width: 10),
                      BreadCrumb(title: 'Cat Food', icon: Icons.pets),
                      SizedBox(width: 10),
                      BreadCrumb(title: 'Dog Food', icon: Icons.restaurant),
                      SizedBox(width: 10),
                      BreadCrumb(title: 'Grooming', icon: Icons.cut),
                      SizedBox(width: 10),
                      BreadCrumb(title: 'Toys', icon: Icons.sports_esports),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  'All Products',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                const SizedBox(height: 12),

                // Responsive Products Grid
                GridView.builder(
                  itemCount: products.length,
                  shrinkWrap: true, // allow grid to size inside the page scroll
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
}
