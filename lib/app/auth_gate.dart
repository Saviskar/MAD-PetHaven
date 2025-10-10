import 'package:flutter/material.dart';
import 'package:pet_haven/screens/login.dart';
import 'package:pet_haven/screens/main_screen.dart';
import 'package:provider/provider.dart';
import '../data/auth_manager.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthManager>(
      builder: (context, auth, _) {
        if (!auth.isInitialized) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        if (auth.isLoggedIn) {
          return auth.isLoggedIn ? const MainScreen() : const Login();
        }

        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Login(),
        );
      },
    );
  }
}
