import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pet_haven/controllers/product_controller.dart';
import 'package:pet_haven/helper/navigation_helper.dart';
import 'package:pet_haven/views/product_detail_page.dart';
import 'package:pet_haven/widgets/custom_card.dart';
import 'package:pet_haven/widgets/custom_app_bar.dart';
import 'package:pet_haven/widgets/hero_banner.dart';
import 'package:pet_haven/widgets/input_field.dart';
import 'package:pet_haven/widgets/our_category.dart';
import 'package:pet_haven/widgets/section_header.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static const Map<String, String> _categoryImages = {
    'Dog Food': 'assets/images/dog_food.png',
    'Cat Food': 'assets/images/dog_kibble.jpg',
    'Dog Toys': 'assets/images/cat_scratching_post.jpg',
    'Cat Toys': 'assets/images/cat_toy_mouse.png',
    'Pet Accessories': 'assets/images/dog_leash.jpg',
    'Pet Grooming': 'assets/images/dog_shampoo.jpg',
    'Pet Health': 'assets/images/cat_litter.jpg',
    'Pet Beds and Furnitures': 'assets/images/dog_bed.jpg',
    // Aliases in case of slight naming variations
    'Pet Beds': 'assets/images/dog_bed.jpg',
    'Accessories': 'assets/images/dog_leash.jpg',
  };

  String _getCategoryImage(String name, String? ApiUrl) {
    if (_categoryImages.containsKey(name)) return _categoryImages[name]!;
    final generic = name.replaceAll('Pet ', '');
    if (_categoryImages.containsKey(generic)) return _categoryImages[generic]!;
    return ApiUrl ?? 'assets/images/dog_food.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: 'Pet Haven'),
      body: SingleChildScrollView(
        // whole page scrolls vertically
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(hintText: 'Search for pet supplies'),
            HeroBanner(),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Our Categories'),

            const SizedBox(height: 15),

            Consumer<ProductController>(
              builder: (context, controller, child) {
                if (controller.isCategoriesLoading &&
                    controller.categories.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.categories.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('No categories found'),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () => NavigationHelper.goToShop(context),
                          child: OurCategory(
                            title: category.name,
                            imagePath: _getCategoryImage(
                              category.name,
                              category.imageUrl,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            SizedBox(height: 20),

            const SectionHeader(title: 'Our Promotions'),

            SizedBox(height: 12),

            Consumer<ProductController>(
              builder: (context, controller, child) {
                if (controller.isPromotedLoading &&
                    controller.promotedProducts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.promotedProducts.isEmpty) {
                  return const SizedBox.shrink(); // Hide if no promotions
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.promotedProducts.map((product) {
                      return CustomCard(
                        title: product.name,
                        imagePath: product.imageUrl,
                        price: product.price,
                        discount: product.discount,
                        width: 140,
                        margin: const EdgeInsets.only(right: 15),
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
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
