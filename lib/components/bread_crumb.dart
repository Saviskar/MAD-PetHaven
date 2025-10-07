import 'package:flutter/material.dart';

class BreadCrumb extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const BreadCrumb({
    super.key,
    required this.title,
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.black, size: 18),
      label: Text(
        title,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      style:
          TextButton.styleFrom(
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (selected) return const Color(0xFFFFE2E2); // active bg
              return states.contains(WidgetState.pressed)
                  ? const Color(0xFFFFD3D3) // pressed bg
                  : const Color(0xFFF2E8E8); // default bg
            }),
            side: WidgetStatePropertyAll(
              BorderSide(
                color: selected
                    ? scheme.primary.withValues(alpha: 0.35)
                    : const Color(0xFFF2E8E8),
              ),
            ),
          ),
    );
  }
}
