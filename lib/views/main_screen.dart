import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pet_haven/widgets/app_bottom_navigation.dart';
import 'package:pet_haven/widgets/low_battery_dialog.dart';
import 'package:pet_haven/controllers/battery_controller.dart';
import 'package:pet_haven/views/cart.dart';
import 'package:pet_haven/views/home.dart';
import 'package:pet_haven/views/profile.dart';
import 'package:pet_haven/views/shop.dart';
import 'package:pet_haven/views/wishlist_page.dart';

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
/// - Monitors battery level and shows a fun warning when low.
class MainScreen extends StatefulWidget {
  /// Creates a [MainScreen] widget.
  ///
  /// [initialIndex] allows the screen to open directly to a specific tab,
  /// such as Shop or Cart. Defaults to 0 (Home).
  const MainScreen({super.key, this.initialIndex = 0});

  /// The index of the tab to open initially. (0 = Home, 1 = Shop, 2 = Cart, 3 = Profile)
  final int initialIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

/// The state class for [MainScreen].
///
/// Handles navigation logic, page view controller, updating
/// the currently selected tab index, and battery monitoring.
class _MainScreenState extends State<MainScreen> {
  /// Controller for managing page navigation.
  late final PageController _controller;

  /// The index of the currently selected bottom navigation tab.
  late int _selectedIndex;

  /// Whether the low battery dialog is currently being displayed.
  bool _isShowingBatteryDialog = false;

  /// The list of pages corresponding to each bottom navigation item.
  ///
  /// The first page is the [Home] widget, followed by placeholders
  /// for Shop, Cart, and Profile pages.
  final List<Widget> _pages = const [
    Home(key: PageStorageKey('home')),
    Shop(key: PageStorageKey('shop')),
    WishlistPage(key: PageStorageKey('wishlist')),
    Cart(key: PageStorageKey('cart')),
    Profile(key: PageStorageKey('profile')),
  ];

  @override
  void initState() {
    super.initState();

    /// Sets the starting tab based on [widget.initialIndex].
    /// This allows navigation directly to a specific tab, such as Shop.
    _selectedIndex = widget.initialIndex;
    _controller = PageController(initialPage: _selectedIndex);

    // Initialize battery monitoring after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeBatteryMonitoring();
    });
  }

  /// Initialize battery monitoring and set up listener for low battery
  void _initializeBatteryMonitoring() {
    final batteryController = context.read<BatteryController>();
    batteryController.initialize();

    // Listen for battery changes
    batteryController.addListener(_checkBatteryAndShowWarning);
  }

  /// Check battery level and show warning dialog if needed
  void _checkBatteryAndShowWarning() {
    if (!mounted) return;

    final batteryController = context.read<BatteryController>();

    if (batteryController.shouldShowWarning && !_isShowingBatteryDialog) {
      _isShowingBatteryDialog = true;

      LowBatteryDialog.show(context, batteryController.batteryLevel, () {
        _isShowingBatteryDialog = false;
        batteryController.markWarningShown();
      });
    }
  }

  @override
  void dispose() {
    /// Remove battery listener to prevent memory leaks
    context.read<BatteryController>().removeListener(
      _checkBatteryAndShowWarning,
    );

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
