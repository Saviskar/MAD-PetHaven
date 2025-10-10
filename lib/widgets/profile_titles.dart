import 'package:flutter/material.dart';
import 'package:pet_haven/theme/color.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final ColorScheme scheme;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // 👇 Adaptive text & arrow colors
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final arrowColor = isDarkMode
        ? Colors.grey.shade400
        : scheme.outline; // softer arrow
    final tileColor = isDarkMode
        ? const Color(0xFF1C1C1C)
        : Colors.white; // background
    final hoverColor = AppColors.primary.withValues(alpha: 0.05);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      splashColor: AppColors.primary.withValues(alpha: 0.2),
      hoverColor: hoverColor,
      child: Container(
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(12),
          border: isDarkMode
              ? Border.all(color: Colors.grey.withValues(alpha: 0.2))
              : Border.all(color: Colors.transparent),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: arrowColor),
          ],
        ),
      ),
    );
  }
}
