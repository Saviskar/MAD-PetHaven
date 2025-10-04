import 'package:flutter/material.dart';

class BreadCrumb extends StatelessWidget {
  final String title;
  final IconData icon;

  const BreadCrumb({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.black, size: 18), // left-side icon
      label: Text(title),
      style:
          TextButton.styleFrom(
            foregroundColor: Colors.black, // text color
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (states) => states.contains(WidgetState.pressed)
                  ? const Color(0xFFFFD3D3) // pressed bg
                  : const Color(0xFFF2E8E8), // default bg
            ),
          ),
    );
  }
}
