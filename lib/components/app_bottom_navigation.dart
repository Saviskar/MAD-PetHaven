import 'package:flutter/material.dart';

/// A custom bottom navigation bar for the Pet Haven app.
///
/// Uses [BottomNavigationBarThemeData] and the active [ColorScheme]
/// so it adapts automatically to light/dark mode.
class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navTheme = theme.bottomNavigationBarTheme;
    final cs = theme.colorScheme;

    return Material(
      elevation: 8,
      // subtle shadow for both modes
      shadowColor: Colors.black.withValues(alpha: 0.08),
      color: navTheme.backgroundColor ?? cs.surface,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,

        backgroundColor: navTheme.backgroundColor ?? cs.surface,
        selectedItemColor: navTheme.selectedItemColor ?? cs.primary,
        unselectedItemColor:
            navTheme.unselectedItemColor ?? cs.onSurfaceVariant,

        showUnselectedLabels: navTheme.showUnselectedLabels ?? true,
        selectedLabelStyle:
            navTheme.selectedLabelStyle ??
            const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            navTheme.unselectedLabelStyle ??
            const TextStyle(fontWeight: FontWeight.w500),

        selectedIconTheme:
            navTheme.selectedIconTheme ?? const IconThemeData(size: 24),
        unselectedIconTheme:
            navTheme.unselectedIconTheme ?? const IconThemeData(size: 24),

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Shop'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
