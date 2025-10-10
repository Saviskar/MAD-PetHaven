import 'package:flutter/material.dart';
import 'package:pet_haven/data/auth_manager.dart';
import 'package:pet_haven/data/user_manager.dart';
import 'package:pet_haven/screens/login.dart';
import 'package:pet_haven/screens/profile_settings.dart';
import 'package:pet_haven/widgets/custom_app_bar.dart';
import 'package:pet_haven/widgets/profile_titles.dart';
import 'package:pet_haven/screens/about_app.dart';
import 'package:pet_haven/theme/color.dart';
import 'package:pet_haven/widgets/wide_button.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final user = context.watch<UserManager>();

    return Scaffold(
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
              user.fullName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: scheme.onSurface,
              ),
            ),
            Text(user.email, style: TextStyle(color: scheme.onSurfaceVariant)),

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
                    title: 'Profile Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProfileSettings()),
                      );
                    },
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
            WideButton(
              placeholder: 'Logout',
              backgroundColor: AppColors.primary,
              onPressed: () async {
                await context.read<AuthManager>().logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const Login()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
