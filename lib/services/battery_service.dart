import 'dart:async';
import 'package:battery_plus/battery_plus.dart';

/// Service class for monitoring device battery level.
///
/// This service provides real-time battery level updates and
/// checks if the battery is below a critical threshold.
class BatteryService {
  final Battery _battery = Battery();

  /// The battery level threshold (20%) below which we show warnings
  static const int lowBatteryThreshold = 20;

  /// Gets the current battery level as a percentage (0-100)
  Future<int> getBatteryLevel() async {
    return await _battery.batteryLevel;
  }

  /// Gets the current battery state (charging, discharging, full, etc.)
  Future<BatteryState> getBatteryState() async {
    return await _battery.batteryState;
  }

  /// Returns a stream of battery level changes
  Stream<BatteryState> get onBatteryStateChanged =>
      _battery.onBatteryStateChanged;

  /// Checks if the battery is currently low (below threshold)
  Future<bool> isBatteryLow() async {
    final level = await getBatteryLevel();
    return level < lowBatteryThreshold;
  }

  /// Checks if the device is currently charging
  Future<bool> isCharging() async {
    final state = await getBatteryState();
    return state == BatteryState.charging || state == BatteryState.full;
  }
}
