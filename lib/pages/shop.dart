import 'package:flutter/material.dart';
import 'package:pet_haven/components/bread_crumb.dart';
import 'package:pet_haven/components/custom_app_bar.dart';
import 'package:pet_haven/components/input_field.dart';
import 'package:pet_haven/components/custom_card.dart';

class Product {
  final String title;
  final String imagePath;
  const Product(this.title, this.imagePath);
}

const products = <Product>[
  Product('Dog Food', 'assets/images/dog_food.png'),
  Product('Dog Food', 'assets/images/dog_food.png'),
  Product('Dog Food', 'assets/images/dog_food.png'),
  Product('Dog Food', 'assets/images/dog_food.png'),
  Product('Dog Food', 'assets/images/dog_food.png'),
  Product('Dog Food', 'assets/images/dog_food.png'),
  Product('Dog Food', 'assets/images/dog_food.png'),
  Product('Dog Food', 'assets/images/dog_food.png'),
];

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: 'Pet Haven'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(hintText: 'Search for pet supplies'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  BreadCrumb(title: 'All Products', icon: Icons.apps),
                  SizedBox(width: 10),
                  BreadCrumb(title: 'Accessories', icon: Icons.shopping_bag),
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

            SizedBox(height: 20),

            Text(
              'All Products',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),

            const SizedBox(height: 12),

            LayoutBuilder(
              builder: (context, constraints) {
                int cols;
                final w = constraints.maxWidth;
                if (w >= 1000)
                  cols = 5;
                else if (w >= 800)
                  cols = 4;
                else if (w >= 600)
                  cols = 3;
                else
                  cols = 2;

                return GridView.builder(
                  shrinkWrap: true, // important inside SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    // Card look in screenshot = square image + label; let height breathe:
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (context, i) {
                    final p = products[i];
                    return CustomCard(title: p.title, imagePath: p.imagePath);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
