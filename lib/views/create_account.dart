import 'package:flutter/material.dart';
import 'package:pet_haven/controllers/auth_controller.dart';
import 'package:pet_haven/views/main_screen.dart';
import 'package:pet_haven/widgets/custom_app_bar.dart';
import 'package:pet_haven/widgets/input_field.dart';
import 'package:pet_haven/theme/color.dart';
import 'package:pet_haven/widgets/wide_button.dart';
import 'package:provider/provider.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedProvince;
  String? _selectedCity;
  bool _submitting = false;

  // Mock Data for Provinces and Cities
  final Map<String, List<String>> _provincesAndCities = {
    'Western': ['Colombo', 'Gampaha', 'Kalutara'],
    'Central': ['Kandy', 'Matale', 'Nuwara Eliya'],
    'Southern': ['Galle', 'Matara', 'Hambantota'],
    'Northern': ['Jaffna', 'Kilinochchi', 'Mannar'],
    'Eastern': ['Trincomalee', 'Batticaloa', 'Ampara'],
    'North Western': ['Kurunegala', 'Puttalam'],
    'North Central': ['Anuradhapura', 'Polonnaruwa'],
    'Uva': ['Badulla', 'Monaragala'],
    'Sabaragamuwa': ['Ratnapura', 'Kegalle'],
  };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedProvince == null || _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Province and City')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() => _submitting = true);

    final success = await context.read<AuthController>().register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      mobile: _mobileController.text.trim(),
      province: _selectedProvince!,
      city: _selectedCity!,
      address: _addressController.text.trim(),
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );

    setState(() => _submitting = false);

    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } else if (mounted) {
      final error =
          context.read<AuthController>().error ?? 'Registration failed';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: 'Pet Haven'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                InputField(
                  hintText: 'Full Name',
                  controller: _nameController,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 12),
                InputField(
                  hintText: 'Email Address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      (v == null || !v.contains('@')) ? 'Invalid email' : null,
                ),
                const SizedBox(height: 12),
                InputField(
                  hintText: 'Mobile Number',
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Mobile is required' : null,
                ),
                const SizedBox(height: 12),

                // Province Dropdown
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Province'),
                  dropdownColor: AppColors.background,
                  value: _selectedProvince,
                  items: _provincesAndCities.keys
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedProvince = val;
                      _selectedCity = null; // Reset city
                    });
                  },
                  validator: (v) => v == null ? 'Select Province' : null,
                ),
                const SizedBox(height: 12),

                // City Dropdown
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('City'),
                  dropdownColor: AppColors.background,
                  value: _selectedCity,
                  items: _selectedProvince == null
                      ? []
                      : _provincesAndCities[_selectedProvince]!
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                  onChanged: _selectedProvince == null
                      ? null
                      : (val) => setState(() => _selectedCity = val),
                  validator: (v) => v == null ? 'Select City' : null,
                ),

                const SizedBox(height: 12),
                InputField(
                  hintText: 'Delivery Address',
                  controller: _addressController,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Address is required' : null,
                ),
                const SizedBox(height: 12),
                InputField(
                  hintText: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (v) =>
                      (v == null || v.length < 8) ? 'Min 8 chars' : null,
                ),
                const SizedBox(height: 12),
                InputField(
                  hintText: 'Confirm Password',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),

                const SizedBox(height: 24),
                WideButton(
                  placeholder: _submitting ? 'Creating...' : 'Create Account',
                  backgroundColor: AppColors.primary,
                  onPressed: _submitting ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}
