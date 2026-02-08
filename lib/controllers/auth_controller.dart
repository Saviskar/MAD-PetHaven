import 'package:flutter/foundation.dart';
import 'package:pet_haven/models/user_model.dart';
import 'package:pet_haven/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _initialized = false;
  bool _loggedIn = false;
  User? _currentUser;
  bool _loading = false;
  String? _error;

  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;
  User? get currentUser => _currentUser;
  bool get isLoading => _loading;
  String? get error => _error;

  AuthController() {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    _loggedIn = await _authService.isLoggedIn();
    _initialized = true;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);
      if (user != null) {
        _loggedIn = true;
        _currentUser = user;
        notifyListeners();
        return true;
      }
      _error = 'Login failed';
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _loading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String mobile,
    required String province,
    required String city,
    required String address,
    required String password,
    required String passwordConfirmation,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authService.register(
        name: name,
        email: email,
        mobile: mobile,
        province: province,
        city: city,
        address: address,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      if (user != null) {
        _loggedIn = true;
        _currentUser = user;
        notifyListeners();
        return true;
      }
      _error = 'Registration failed';
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _loading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> logout() async {
    await _authService.logout();
    _loggedIn = false;
    _currentUser = null;
    notifyListeners();
  }
}
