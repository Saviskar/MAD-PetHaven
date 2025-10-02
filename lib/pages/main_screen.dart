import 'package:flutter/material.dart';
import 'package:pet_haven/components/app_bottom_navigation.dart';
import 'package:pet_haven/pages/home.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Home(),
    Center(child: Text("Shop Page")),
    Center(child: Text("Cart Page")),
    Center(child: Text("Profile Page")),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
