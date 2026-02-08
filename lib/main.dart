import 'package:flutter/material.dart';
import 'package:pet_haven/app/auth_gate.dart';
import 'package:pet_haven/controllers/auth_controller.dart';
import 'package:pet_haven/controllers/user_controller.dart';
import 'package:pet_haven/controllers/product_controller.dart';
import 'package:pet_haven/controllers/wishlist_controller.dart';
import 'package:pet_haven/theme/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => WishlistController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Haven',
      themeMode: ThemeMode.system,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      home: const AuthGate(),
    );
  }
}
