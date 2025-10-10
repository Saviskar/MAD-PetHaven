import 'package:flutter/material.dart';
import 'package:pet_haven/screens/main_screen.dart';

class NavigationHelper {
  /// Navigates to the Shop tab in [MainScreen].
  static void goToShop(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainScreen(initialIndex: 1)),
      (route) => false,
    );
  }
}
