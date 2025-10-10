import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager extends ChangeNotifier {
  static const _kLoggedIn = 'logged_in';

  bool _initialized = false;
  bool _loggedIn = false;

  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;

  AuthManager() {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    _loggedIn = prefs.getBool(_kLoggedIn) ?? false;
    _initialized = true;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    final ok = email.contains('@') && password.length >= 4;
    if (!ok) return false;
    _loggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, true);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _loggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, false);
    notifyListeners();
  }
}
