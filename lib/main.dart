import 'package:flutter/material.dart';
import 'package:pet_haven/pages/login.dart';
import 'package:pet_haven/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: buildTheme(),
      home: Login(),
    );
  }
}
