import 'package:flutter/material.dart';
import 'package:pet_haven/theme/color.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const InputField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // 👇 Define adaptive colors for dark and light modes
    final backgroundColor = isDarkMode
        ? const Color(0xFF1E1E1E) // dark surface
        : AppColors.background;

    final hintColor = isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600;

    final textColor = isDarkMode ? Colors.white : Colors.black;

    final borderColor = isDarkMode
        ? Colors.grey.withValues(alpha: 0.4)
        : Colors.grey.withValues(alpha: 0.2);

    return Column(
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          validator: validator,
          cursorColor: AppColors.primary,
          style: TextStyle(color: textColor), // 👈 text color adapts
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: hintColor), // 👈 adaptive hint
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: backgroundColor, // 👈 adaptive background
            // 👇 border styles
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
