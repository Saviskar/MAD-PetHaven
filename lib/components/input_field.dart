import 'package:flutter/material.dart';
import 'package:pet_haven/theme/color.dart';

class InputField extends StatelessWidget {
  final String hintText;

  const InputField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.background,
            hintText: hintText,
          ),
        ),

        SizedBox(height: 20),
      ],
    );
  }
}
