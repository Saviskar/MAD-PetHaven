import 'package:flutter/material.dart';
import 'package:pet_haven/widgets/custom_app_bar.dart';
import 'package:pet_haven/widgets/input_field.dart';
import 'package:pet_haven/theme/color.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: 'Pet Haven'),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create Account',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
            ),
            SizedBox(height: 20),
            InputField(hintText: 'Full Name'),
            InputField(hintText: 'Email Address'),
            InputField(hintText: 'Mobile Number'),
            InputField(hintText: 'Delivery Address'),
            InputField(hintText: 'Password'),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Gender',
                filled: true,
                fillColor: AppColors.background, // same as your input field bg
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
              dropdownColor: AppColors.background,
              icon: const Icon(
                Icons.arrow_drop_down_rounded,
                color: AppColors.primary,
              ),
              items: const [
                DropdownMenuItem(value: "Male", child: Text('Male')),
                DropdownMenuItem(value: "Female", child: Text('Female')),
                DropdownMenuItem(value: "Other", child: Text('Other')),
              ],
              onChanged:
                  (
                    value,
                  ) {}, // keep empty or null if you don’t want it to do anything
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Create Account'),
            ),
            SizedBox(height: 20),
            Text(
              'Forgotten pasword?',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
