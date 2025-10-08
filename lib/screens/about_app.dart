import 'package:flutter/material.dart';
import 'package:pet_haven/widgets/custom_app_bar.dart';
import 'package:pet_haven/theme/color.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'About App'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App logo
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'Pet Haven',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // About section
            Text(
              'About the App',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              'Pet Haven is your all-in-one companion for pet care essentials. '
              'Shop for food, toys, accessories, and grooming products with ease. '
              'Our app is designed to make pet parenting convenient, reliable, and joyful — right from your mobile device.',
              style: TextStyle(color: cs.onSurfaceVariant, height: 1.5),
            ),

            const SizedBox(height: 30),

            // Developer credits
            Text(
              'Developed By',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              'Saviskar Thiruchelvam\nAPIIT Sri Lanka\nMobile Application Development Project – 2025',
              style: TextStyle(color: cs.onSurfaceVariant, height: 1.5),
            ),

            const Spacer(),

            // Footer
            Center(
              child: Text(
                '© 2025 Pet Haven. All rights reserved.',
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
