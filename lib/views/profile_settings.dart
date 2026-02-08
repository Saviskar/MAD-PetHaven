import 'package:flutter/material.dart';
import 'package:pet_haven/controllers/user_controller.dart';
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
  late TextEditingController phoneCtrl;

  @override
  void initState() {
    super.initState();
    // Initialize with empty or loading state
    nameCtrl = TextEditingController();
    phoneCtrl = TextEditingController();

    // Fetch user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    final controller = context.read<UserController>();
    await controller.fetchUser();

    // Update controllers with fetched data
    if (mounted) {
      setState(() {
        nameCtrl.text = controller.fullName;
        phoneCtrl.text = controller.mobile;
      });
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  void _saveChanges(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await context.read<UserController>().updateProfile(
        fullName: nameCtrl.text.trim(),
        mobile: phoneCtrl.text.trim(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
      }
    }
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

              const SizedBox(height: 25),

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
