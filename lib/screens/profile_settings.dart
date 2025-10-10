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
  final _formKey = GlobalKey<FormState>();

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
    if (!_formKey.currentState!.validate()) return;

    context.read<UserManager>().updateProfile(
      fullName: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      mobile: phoneCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      password: passCtrl.text.trim(),
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputField(
                controller: nameCtrl,
                hintText: 'Full Name',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your full name';
                  } else if (val.trim().length < 3) {
                    return 'Name must be at least 3 characters long';
                  }
                  return null;
                },
              ),

              InputField(
                controller: emailCtrl,
                hintText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your email address';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(val.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),

              InputField(
                controller: phoneCtrl,
                hintText: 'Mobile Number',
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  final phoneRegex = RegExp(r'^[0-9]{10}$');
                  if (!phoneRegex.hasMatch(val.trim())) {
                    return 'Mobile number must be 10 digits';
                  }
                  return null;
                },
              ),

              InputField(
                controller: addressCtrl,
                hintText: 'Delivery Address',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your delivery address';
                  }
                  return null;
                },
              ),

              InputField(
                controller: passCtrl,
                hintText: 'Password',
                obscureText: true,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your password';
                  } else if (val.trim().length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                initialValue: gender,
                items: const [
                  DropdownMenuItem(value: "Male", child: Text('Male')),
                  DropdownMenuItem(value: "Female", child: Text('Female')),
                  DropdownMenuItem(value: "Other", child: Text('Other')),
                ],
                onChanged: (value) => setState(() => gender = value!),
                decoration: const InputDecoration(labelText: "Gender"),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              WideButton(
                placeholder: 'Save Changes',
                backgroundColor: AppColors.primary,
                onPressed: () => _saveChanges(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
