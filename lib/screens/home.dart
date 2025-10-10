import 'package:flutter/material.dart';
import 'package:pet_haven/helper/navigation_helper.dart';
import 'package:pet_haven/widgets/custom_card.dart';
import 'package:pet_haven/widgets/custom_app_bar.dart';
import 'package:pet_haven/widgets/hero_banner.dart';
import 'package:pet_haven/widgets/input_field.dart';
import 'package:pet_haven/widgets/our_category.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
            const Text(
              'Our Categories',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),

            const SizedBox(height: 15),

            // scrolls horizontally
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => NavigationHelper.goToShop(context),
                    child: OurCategory(
                      title: 'Accessories',
                      imagePath: 'assets/images/dog_food.png',
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => NavigationHelper.goToShop(context),
                    child: OurCategory(
                      title: 'Food',
                      imagePath: 'assets/images/dog_food.png',
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => NavigationHelper.goToShop(context),
                    child: OurCategory(
                      title: 'Grooming',
                      imagePath: 'assets/images/dog_food.png',
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => NavigationHelper.goToShop(context),
                    child: OurCategory(
                      title: 'Toys',
                      imagePath: 'assets/images/dog_food.png',
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            const Text(
              'Our Promotions',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),

            SizedBox(height: 12),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CustomCard(
                    title: 'Food',
                    imagePath: 'assets/images/dog_food.png',
                    width: 140,
                    margin: const EdgeInsets.only(right: 15),
                  ),
                  CustomCard(
                    title: 'Grooming',
                    imagePath: 'assets/images/dog_food.png',
                    width: 140,
                    margin: const EdgeInsets.only(right: 15),
                  ),
                  CustomCard(
                    title: 'Toys',
                    imagePath: 'assets/images/dog_food.png',
                    width: 140,
                    margin: const EdgeInsets.only(right: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
