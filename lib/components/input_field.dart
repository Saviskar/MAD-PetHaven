import 'package:flutter/material.dart';
import 'package:pet_haven/theme/color.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const InputField({super.key, required this.hintText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 1.8),
            ),
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
