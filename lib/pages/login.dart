import 'package:flutter/material.dart';
import 'package:pet_haven/components/input_field.dart';
import 'package:pet_haven/components/wide_button.dart';
import 'package:pet_haven/theme/color.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
              'Welcome Back',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
            ),
            SizedBox(height: 20),
            InputField(hintText: 'Email Address'),
            InputField(
              hintText: 'Password',
            ), // make two rows one has the text password and other one has the view password button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text('Forgot password?')],
            ),
            SizedBox(height: 20),
            WideButton(
              placeholder: 'Create Account',
              backgroundColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
