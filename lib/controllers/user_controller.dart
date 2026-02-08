import 'package:flutter/material.dart';
import 'package:pet_haven/models/user_model.dart';
import 'package:pet_haven/services/auth_service.dart';

class UserController extends ChangeNotifier {
  static final UserController _instance = UserController._internal();
  factory UserController() => _instance;
  UserController._internal();

  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  // Getters for UI compatibility, falling back to empty string if user is null
  String get fullName => _user?.name ?? '';
  String get email => _user?.email ?? '';
  String get mobile => _user?.mobile ?? '';
  String get addressLine => _user?.addressLine ?? '';
  String get city => _user?.city ?? '';
  String get province => _user?.province ?? '';
  String get password => ''; // Don't expose password
  String get gender => _user?.gender ?? 'Male';

  Future<void> fetchUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _authService.fetchUser();
    } catch (e) {
      debugPrint('Error fetching user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? fullName,
    String? email,
    String? mobile,
    String? addressLine,
    String? city,
    String? province,
    String? password,
    String? gender,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = {
        if (fullName != null) 'name': fullName,
        if (email != null) 'email': email,
        if (mobile != null) 'mobile': mobile,
        if (addressLine != null) 'addressline': addressLine,
        if (city != null) 'city': city,
        if (province != null) 'province': province,
        if (password != null && password.isNotEmpty) 'password': password,
        if (gender != null) 'gender': gender,
      };

      await _authService.updateProfile(data);
      await fetchUser(); // Refresh data
    } catch (e) {
      debugPrint('Error updating profile: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
