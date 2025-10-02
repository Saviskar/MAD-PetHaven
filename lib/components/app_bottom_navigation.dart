import 'package:flutter/material.dart';
import 'package:pet_haven/theme/color.dart';

/// A custom bottom navigation bar for the Pet Haven app.
///
/// Wraps Flutter's [BottomNavigationBar] inside a [Material] widget
/// to provide elevation, shadow, and consistent styling across pages.
///
/// Features:
/// - Four tabs: Home, Shop, Cart, and Profile.
/// - Active tab highlighted with [AppColors.primary].
/// - Optional shadow and elevation for a raised appearance.
/// - Supports label and icon customization.
/// - Exposes [currentIndex] and [onTap] to allow parent widgets to
///   control and respond to navigation changes.
class AppBottomNavigationBar extends StatelessWidget {
  /// The index of the currently selected tab.
  ///
  /// Determines which tab is highlighted as active.
  final int currentIndex;

  /// Callback triggered when a navigation item is tapped.
  ///
  /// Provides the tapped item's index.
  final ValueChanged<int> onTap;

  /// Creates a Pet Haven [AppBottomNavigationBar].
  ///
  /// The [currentIndex] and [onTap] must not be null.
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      /// Provides elevation and drop shadow to the navigation bar.
      elevation: 8,

      /// Semi-transparent shadow color for subtle depth.
      shadowColor: Colors.black.withValues(alpha: 0.08),

      /// Ensures a consistent white background regardless of theme.
      color: Colors.white,

      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,

        // Colors
        backgroundColor: AppColors.navbarBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.navbarUnselectedItem,

        // Label styles
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),

        // Icon themes (equal sizes to prevent bounce effect)
        selectedIconTheme: const IconThemeData(size: 24),
        unselectedIconTheme: const IconThemeData(size: 24),

        // Navigation items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.search, size: 28),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            activeIcon: Icon(Icons.shopping_cart, size: 28),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person, size: 28),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
