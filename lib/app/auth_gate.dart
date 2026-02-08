import 'package:flutter/material.dart';
import 'package:pet_haven/views/login.dart';
import 'package:pet_haven/views/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:pet_haven/controllers/auth_controller.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, _) {
        if (!auth.isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (auth.isLoggedIn) {
          return const MainScreen();
        }

        return const Login();
      },
    );
  }
}
