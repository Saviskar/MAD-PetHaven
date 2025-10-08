// lib/pages/login.dart
import 'package:flutter/material.dart';
import 'package:pet_haven/pages/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:pet_haven/components/custom_app_bar.dart';
import 'package:pet_haven/components/input_field.dart';
import 'package:pet_haven/components/wide_button.dart';
import 'package:pet_haven/theme/color.dart';
import 'package:pet_haven/data/auth_manager.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _showPassword = false;
  bool _submitting = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final ok = await context.read<AuthManager>().login(
      email: _email.text.trim(),
      password: _password.text,
    );

    setState(() => _submitting = false);

    if (ok && mounted) {
      // Option A: if you keep AuthGate, this is still safe
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    }

    // On success, AuthGate rebuilds and shows MainScreen automatically.
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(appBarTitle: 'Pet Haven'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome Back',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                  const SizedBox(height: 20),

                  // Email
                  InputField(
                    hintText: 'Email Address',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => (v == null || !v.contains('@'))
                        ? 'Enter a valid email'
                        : null,
                  ),

                  // Password with show/hide
                  const SizedBox(height: 12),
                  InputField(
                    hintText: 'Password',
                    controller: _password,
                    obscureText: !_showPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _showPassword = !_showPassword),
                    ),
                    validator: (v) =>
                        (v == null || v.length < 4) ? 'Min 4 characters' : null,
                  ),

                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [Text('Forgot password?')],
                  ),

                  const SizedBox(height: 20),

                  // Login button
                  WideButton(
                    placeholder: _submitting ? 'Signing in...' : 'Login',
                    backgroundColor: AppColors.primary,
                    onPressed: _submitting ? null : _submit,
                  ),

                  const SizedBox(height: 12),

                  // Optional: "Create Account" (non-functional in demo)
                  TextButton(
                    onPressed: () {},
                    child: const Text('Create Account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
