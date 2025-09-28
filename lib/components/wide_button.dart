import 'package:flutter/material.dart';
import 'package:pet_haven/theme/color.dart';

class WideButton extends StatelessWidget {
  final String placeholder;
  final Color backgroundColor;

  const WideButton({
    super.key,
    required this.placeholder,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(placeholder),
    );
  }
}
