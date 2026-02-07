import 'package:dio/dio.dart';
import 'package:pet_haven/models/user_model.dart';
import 'package:pet_haven/services/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<User?> login(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        '/api/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['access_token'] != null) {
          await _apiService.saveToken(data['access_token']);
        }
        return User.fromJson(data['data']);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Login failed');
      }
      throw Exception('Connection error');
    }
  }

  Future<User?> register({
    required String name,
    required String email,
    required String mobile,
    required String province, // Assuming these come from UI
    required String city,
    required String address,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/api/register',
        data: {
          'name': name,
          'email': email,
          'mobile': mobile,
          'role_id': 2, // Assuming default role for now or derived from select
          'province': province, // Adjust key if API expects different naming
          'city': city,
          'address': address,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['access_token'] != null) {
          await _apiService.saveToken(data['access_token']);
        }
        return User.fromJson(data['data']);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null) {
        // Validation errors usually come as { "message": "...", "errors": { ... } }
        final data = e.response?.data;
        if (data is Map<String, dynamic> && data.containsKey('errors')) {
          final errors = data['errors'] as Map<String, dynamic>;
          final messages = errors.values
              .map((v) => (v as List).join(', '))
              .join('\n');
          throw Exception(messages);
        }
        throw Exception(data['message'] ?? 'Registration failed');
      }
      throw Exception('Connection error: ${e.message}');
    }
  }

  Future<void> logout() async {
    try {
      // Optional: call logout endpoint if exists
      // await _apiService.dio.post('/api/logout');
      await _apiService.deleteToken();
    } catch (e) {
      // Ignore logout errors (maybe token invalid)
      await _apiService.deleteToken();
    }
  }

  Future<bool> isLoggedIn() async {
    return await _apiService.hasToken();
  }
}
