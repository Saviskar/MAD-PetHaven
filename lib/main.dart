import 'package:flutter/material.dart';
import 'package:pet_haven/app/auth_gate.dart';
import 'package:pet_haven/data/auth_manager.dart';
import 'package:pet_haven/data/user_manager.dart';
import 'package:pet_haven/theme/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthManager()),
        ChangeNotifierProvider(create: (_) => UserManager()),
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
