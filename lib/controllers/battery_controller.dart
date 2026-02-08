import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:pet_haven/services/battery_service.dart';

/// Controller for managing battery monitoring state.
///
/// This controller monitors the battery level and triggers callbacks
/// when the battery drops below a specified threshold. It also manages
/// the state to ensure warnings are not shown repeatedly.
class BatteryController extends ChangeNotifier {
  final BatteryService _batteryService = BatteryService();

  int _batteryLevel = 100;
  bool _isLowBattery = false;
  bool _hasShownWarning = false;
  bool _isCharging = false;

  StreamSubscription<BatteryState>? _batteryStateSubscription;
  Timer? _batteryCheckTimer;

  /// Current battery level (0-100)
  int get batteryLevel => _batteryLevel;

  /// Whether the battery is currently below the low threshold
  bool get isLowBattery => _isLowBattery;

  /// Whether the low battery warning has already been shown
  bool get hasShownWarning => _hasShownWarning;

  /// Whether the device is currently charging
  bool get isCharging => _isCharging;

  /// Whether we should show the low battery warning
  bool get shouldShowWarning =>
      _isLowBattery && !_hasShownWarning && !_isCharging;

  /// Initialize battery monitoring
  Future<void> initialize() async {
    await _checkBatteryLevel();
    await _checkChargingState();

    // Listen to battery state changes (charging/discharging)
    _batteryStateSubscription = _batteryService.onBatteryStateChanged.listen((
      state,
    ) {
      _isCharging =
          state == BatteryState.charging || state == BatteryState.full;

      // Reset warning flag when user starts charging
      if (_isCharging) {
        _hasShownWarning = false;
      }

      notifyListeners();
    });

    // Periodically check battery level (every 30 seconds)
    _batteryCheckTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkBatteryLevel(),
    );
  }

  /// Check current battery level
  Future<void> _checkBatteryLevel() async {
    try {
      _batteryLevel = await _batteryService.getBatteryLevel();
      _isLowBattery = _batteryLevel < BatteryService.lowBatteryThreshold;
      notifyListeners();
    } catch (e) {
      debugPrint('🔋 Error checking battery level: $e');
    }
  }

  /// Check if device is charging
  Future<void> _checkChargingState() async {
    try {
      _isCharging = await _batteryService.isCharging();
      notifyListeners();
    } catch (e) {
      debugPrint('🔋 Error checking charging state: $e');
    }
  }

  /// Mark that the warning has been shown
  void markWarningShown() {
    _hasShownWarning = true;
    notifyListeners();
  }

  /// Reset the warning flag (useful when battery goes back above threshold)
  void resetWarning() {
    _hasShownWarning = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _batteryStateSubscription?.cancel();
    _batteryCheckTimer?.cancel();
    super.dispose();
  }
}
