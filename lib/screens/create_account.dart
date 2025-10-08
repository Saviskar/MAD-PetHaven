import 'package:flutter/material.dart';
import 'package:pet_haven/widgets/custom_app_bar.dart';
import 'package:pet_haven/widgets/input_field.dart';
import 'package:pet_haven/theme/color.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

  // to the below then only "automaticallyImplyLeading: true," will work
  //   Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => const CreateAccount()),
  // );

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
