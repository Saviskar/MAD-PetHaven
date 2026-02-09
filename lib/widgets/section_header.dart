import 'package:flutter/material.dart';

/// A reusable section header widget with consistent styling.
///
/// Used for section titles like "Our Categories", "Our Promotions", etc.
class SectionHeader extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;

  const SectionHeader({
    super.key,
    required this.title,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontWeight: fontWeight, fontSize: fontSize),
    );
  }
}
