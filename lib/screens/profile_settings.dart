import 'package:flutter/material.dart';
import 'package:pet_haven/data/user_manager.dart';
import 'package:pet_haven/theme/color.dart';
import 'package:pet_haven/widgets/custom_app_bar.dart';
import 'package:pet_haven/widgets/input_field.dart';
import 'package:pet_haven/widgets/wide_button.dart';
import 'package:provider/provider.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController passCtrl;
  String gender = "Male";

  @override
  void initState() {
    super.initState();
    final user = UserManager();
    nameCtrl = TextEditingController(text: user.fullName);
    emailCtrl = TextEditingController(text: user.email);
    phoneCtrl = TextEditingController(text: user.mobile);
    addressCtrl = TextEditingController(text: user.address);
    passCtrl = TextEditingController(text: user.password);
    gender = user.gender;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _saveChanges(BuildContext context) {
    context.read<UserManager>().updateProfile(
      fullName: nameCtrl.text,
      email: emailCtrl.text,
      mobile: phoneCtrl.text,
      address: addressCtrl.text,
      password: passCtrl.text,
      gender: gender,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: 'Profile Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InputField(controller: nameCtrl, hintText: 'Full Name'),
            InputField(controller: emailCtrl, hintText: 'Email Address'),
            InputField(controller: phoneCtrl, hintText: 'Mobile Number'),
            InputField(controller: addressCtrl, hintText: 'Delivery Address'),
            InputField(controller: passCtrl, hintText: 'Password'),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              items: const [
                DropdownMenuItem(value: "Male", child: Text('Male')),
                DropdownMenuItem(value: "Female", child: Text('Female')),
                DropdownMenuItem(value: "Other", child: Text('Other')),
              ],
              onChanged: (value) => setState(() => gender = value!),
              decoration: const InputDecoration(labelText: "Gender"),
            ),
            const SizedBox(height: 20),
            WideButton(
              placeholder: 'Save Changes',
              backgroundColor: AppColors.primary,
              onPressed: () => _saveChanges(context),
            ),
          ],
        ),
      ),
    );
  }
}
