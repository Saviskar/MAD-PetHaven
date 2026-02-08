import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:pet_haven/services/connectivity_service.dart';

/// Controller for managing connectivity state throughout the app.
///
/// Exposes connectivity status to UI widgets via ChangeNotifier,
/// allowing widgets to react to online/offline state changes.
class ConnectivityController extends ChangeNotifier {
  final ConnectivityService _connectivityService = ConnectivityService();

  bool _isOnline = true;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Whether the device is currently online
  bool get isOnline => _isOnline;

  /// Whether the device is currently offline
  bool get isOffline => !_isOnline;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial status
    _isOnline = await _connectivityService.isOnline();
    notifyListeners();

    // Listen for changes
    _subscription = _connectivityService.onConnectivityChanged.listen((
      results,
    ) {
      final wasOnline = _isOnline;
      _isOnline = _connectivityService.isConnectedFromResults(results);

      if (wasOnline != _isOnline) {
        debugPrint(
          '📶 Connectivity changed: ${_isOnline ? "Online" : "Offline"}',
        );
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
