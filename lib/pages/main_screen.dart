import 'package:flutter/material.dart';
import 'package:pet_haven/components/app_bottom_navigation.dart';
import 'package:pet_haven/pages/cart.dart';
import 'package:pet_haven/pages/home.dart';
import 'package:pet_haven/pages/shop.dart';

/// The main container widget for the Pet Haven app.
///
/// [MainScreen] manages bottom navigation and page transitions using
/// a [PageView] and a custom [AppBottomNavigationBar]. It is responsible
/// for keeping track of the currently selected tab and synchronizing
/// both the navigation bar and the page view.
///
/// Features:
/// - Hosts four tabs: Home, Shop, Cart, and Profile.
/// - Uses [PageController] for smooth animated page transitions.
/// - Keeps navigation state in [_selectedIndex].
/// - Provides swipe navigation between tabs with bounce physics.
class MainScreen extends StatefulWidget {
  /// Creates a [MainScreen] widget.
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

/// The state class for [MainScreen].
///
/// Handles navigation logic, page view controller, and updating
/// the currently selected tab index.
class _MainScreenState extends State<MainScreen> {
  /// Controller for managing page navigation.
  final PageController _controller = PageController();

  /// The index of the currently selected bottom navigation tab.
  int _selectedIndex = 0;

  /// The list of pages corresponding to each bottom navigation item.
  ///
  /// The first page is the [Home] widget, followed by placeholders
  /// for Shop, Cart, and Profile pages.
  final List<Widget> _pages = const [
    Home(key: PageStorageKey('home')),
    Shop(key: PageStorageKey('shop')),
    Cart(key: PageStorageKey('cart')),
    Center(child: Text("Cart Page")),
    Center(child: Text("Profile Page")),
  ];

  @override
  void dispose() {
    /// Disposes the [PageController] when the widget is removed
    /// from the widget tree to free up resources.
    _controller.dispose();
    super.dispose();
  }

  /// Handles taps on the bottom navigation bar.
  ///
  /// Updates the [_selectedIndex] and animates the [PageController]
  /// to the corresponding page with a smooth cubic transition.
  void _onTap(int index) {
    setState(() => _selectedIndex = index);
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Displays the active page using a [PageView].
      ///
      /// Swiping between pages also updates [_selectedIndex] to keep
      /// the navigation bar and page view in sync.
      body: PageView(
        controller: _controller,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        physics: const BouncingScrollPhysics(),
        children: _pages,
      ),

      /// The custom bottom navigation bar that reflects the current
      /// [_selectedIndex] and notifies [_onTap] when a tab is selected.
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}
