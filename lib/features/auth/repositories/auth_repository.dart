import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRepository {
  Future<bool> checkSession();
  Future<void> login(String phoneNumber);
  Future<bool> verifyOtp(String otp);
  Future<void> logout();
}

class MockAuthRepository implements AuthRepository {
  static const String _sessionKey = 'auth_session_token';

  @override
  Future<bool> checkSession() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_sessionKey);
  }

  @override
  Future<void> login(String phoneNumber) async {
    // Simulate network delay for sending OTP
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<bool> verifyOtp(String otp) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Accept any 4-digit OTP for the mock
    if (otp.length == 4) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionKey, 'mock_token_123');
      return true;
    }
    return false;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});
