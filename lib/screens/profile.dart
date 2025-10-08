import 'package:flutter/material.dart';
import 'package:pet_haven/components/custom_app_bar.dart';
import 'package:pet_haven/components/profile_titles.dart';
import 'package:pet_haven/screens/about_app.dart';
import 'package:pet_haven/theme/color.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      // backgroundColor: scheme.surface,
      appBar: CustomAppBar(appBarTitle: 'Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile avatar
            const CircleAvatar(
              // backgroundColor: AppColors.primary,
              radius: 50,
              backgroundImage: AssetImage('images/user.png'),
            ),
            const SizedBox(height: 12),

            // Name + email
            Text(
              'Saviskar Thiruchelvam',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: scheme.onSurface,
              ),
            ),
            Text(
              'saviskar123@gmail.com',
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),

            const SizedBox(height: 24),

            // Info Card
            Card(
              color: AppColors.background,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ProfileTile(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {},
                    scheme: scheme,
                  ),
                  ProfileTile(
                    icon: Icons.info_outline,
                    title: 'About App',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutApp()),
                      );
                    },
                    scheme: scheme,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red.shade500,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
