import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for monitoring network connectivity status.
///
/// Provides real-time updates on connectivity changes and
/// methods to check if the device is currently online.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Stream of connectivity changes
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  /// Check current connectivity status
  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected(result);
  }

  /// Determine if any of the connectivity results indicate a connection
  bool _isConnected(List<ConnectivityResult> results) {
    return results.any(
      (result) =>
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet,
    );
  }

  /// Check connectivity from a list of results
  bool isConnectedFromResults(List<ConnectivityResult> results) {
    return _isConnected(results);
  }
}
