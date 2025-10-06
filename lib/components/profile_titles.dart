import 'package:flutter/material.dart';
import 'package:pet_haven/theme/color.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final ColorScheme scheme;

  const ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: scheme.outline),
      onTap: onTap,
    );
  }
}
