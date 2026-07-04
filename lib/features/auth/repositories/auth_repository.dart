import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';
import '../../../core/local_storage/hive_boxes.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/gamification_stats.dart';

abstract class AuthRepository {
  Future<bool> checkSession();
  Future<String> login(String phoneNumber);
  Future<bool> verifyOtp(String phoneNumber, String otp);
  Future<void> register(
      String name, String phoneNumber, int age, String avatarId);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class MockAuthRepository implements AuthRepository {
  static const String _sessionKey = 'active_session_phone';
  final _secureStorage = const FlutterSecureStorage();

  // In-memory storage for the current mock OTP
  String? _currentMockOtp;

  @override
  Future<bool> checkSession() async {
    final value = await _secureStorage.read(key: _sessionKey);
    return value != null;
  }

  @override
  Future<String> login(String phoneNumber) async {
    // Check if user exists in Hive
    final box = HiveBoxes.getUsersBox();
    if (!box.containsKey(phoneNumber)) {
      throw Exception('No account found. Please create an account.');
    }

    // Generate random 4-digit Mock OTP
    final random = Random();
    _currentMockOtp = (1000 + random.nextInt(9000)).toString();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return _currentMockOtp!;
  }

  @override
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (otp == _currentMockOtp) {
      await _secureStorage.write(key: _sessionKey, value: phoneNumber);
      _currentMockOtp = null; // clear after use
      return true;
    }
    return false;
  }

  @override
  Future<void> register(
      String name, String phoneNumber, int age, String avatarId) async {
    final box = HiveBoxes.getUsersBox();
    if (box.containsKey(phoneNumber)) {
      throw Exception('Phone number is already registered. Please login.');
    }

    final random = Random();

    // Generate LRN-XXXXXX ID
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final idString =
        List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
    final newUserId = 'LRN-$idString';

    // Create complete profile with default gamification stats
    final newUser = UserModel(
      phoneNumber: phoneNumber,
      displayName: name,
      age: age,
      avatarId: avatarId,
      userId: newUserId,
      inventory: [avatarId],
      stats: GamificationStats(), // Defaults to 0 XP, Bronze I, etc.
    );

    // Save to Hive
    await box.put(phoneNumber, newUser);

    // Auto log-in by setting session key
    await _secureStorage.write(key: _sessionKey, value: phoneNumber);
  }

  @override
  Future<void> logout() async {
    await _secureStorage.delete(key: _sessionKey);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final activePhone = await _secureStorage.read(key: _sessionKey);

    if (activePhone != null) {
      final box = HiveBoxes.getUsersBox();
      return box.get(activePhone);
    }
    return null;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});
