import 'package:flutter/material.dart';
import 'package:pet_haven/components/input_field.dart';
import 'package:pet_haven/components/wide_button.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pet Haven',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),
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
            InputField(
              hintText: 'Password',
            ), // make two rows one has the text password and other one has the view password button
            WideButton(placeholder: 'Create Account', fillColor: 0xFFE53E3E),
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
