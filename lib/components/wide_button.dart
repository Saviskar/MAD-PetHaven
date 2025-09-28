import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  final String placeholder;
  final int fillColor;

  const WideButton({
    super.key,
    required this.placeholder,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(fillColor),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(placeholder),
    );
  }
}
