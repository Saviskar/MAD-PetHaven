import 'package:flutter/material.dart';

class UserManager extends ChangeNotifier {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;
  UserManager._internal();

  String _fullName = "Saviskar Thiruchelvam";
  String _email = "saviskar123@gmail.com";
  String _mobile = "0771234567";
  String _address = "Colombo, Sri Lanka";
  String _password = "password123";
  String _gender = "Male";

  String get fullName => _fullName;
  String get email => _email;
  String get mobile => _mobile;
  String get address => _address;
  String get password => _password;
  String get gender => _gender;

  void updateProfile({
    String? fullName,
    String? email,
    String? mobile,
    String? address,
    String? password,
    String? gender,
  }) {
    if (fullName != null) _fullName = fullName;
    if (email != null) _email = email;
    if (mobile != null) _mobile = mobile;
    if (address != null) _address = address;
    if (password != null) _password = password;
    if (gender != null) _gender = gender;
    notifyListeners();
  }
}
