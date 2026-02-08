import 'package:flutter/material.dart';
import 'package:pet_haven/app/auth_gate.dart';
import 'package:pet_haven/controllers/auth_controller.dart';
import 'package:pet_haven/controllers/user_controller.dart';
import 'package:pet_haven/controllers/product_controller.dart';
import 'package:pet_haven/controllers/wishlist_controller.dart';
import 'package:pet_haven/controllers/battery_controller.dart';
import 'package:pet_haven/controllers/connectivity_controller.dart';
import 'package:pet_haven/theme/theme.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => WishlistController()),
        ChangeNotifierProvider(create: (_) => BatteryController()),
        ChangeNotifierProvider(create: (_) => ConnectivityController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // Force rebuild when system brightness changes
    debugPrint(
      '🌓 Platform brightness changed to: ${WidgetsBinding.instance.platformDispatcher.platformBrightness}',
    );
    setState(() {});
  }

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
