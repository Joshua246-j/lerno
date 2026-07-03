import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/shared/models/user_profile.dart';
import 'package:lerno/features/gamification/application/streak_service.dart';

final streakServiceProvider = Provider<StreakService>((ref) {
  return StreakService();
});

class AuthNotifier extends StateNotifier<UserProfile?> {
  final StreakService _streakService;

  AuthNotifier(this._streakService) : super(null);

  Future<void> loginWithPhone(String phoneNumber) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate fetching user from backend
    UserProfile fetchedUser = UserProfile(
      id: '#AK-1234',
      displayName: 'AstroKid7',
      phoneNumber: phoneNumber,
      grade: 2,
      coins: 150,
      trophies: 200,
      currentStreak: 99, // Testing streak logic (should become 100 on login)
      lastLoginDate: DateTime.now().subtract(const Duration(days: 1)),
      league: 'Bronze',
      badges: ['word_warrior', 'math_master', 'science_explorer'],
    );

    // Apply dynamic streak logic
    state = _streakService.calculateDailyStreak(fetchedUser);
  }

  void logout() {
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, UserProfile?>((ref) {
  final streakService = ref.watch(streakServiceProvider);
  return AuthNotifier(streakService);
});
