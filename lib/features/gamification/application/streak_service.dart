import 'package:lerno/shared/models/user_profile.dart';

class StreakService {
  /// Analyzes the user's last login date and updates their streak.
  /// Should be called immediately upon successful authentication.
  UserProfile calculateDailyStreak(UserProfile user) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (user.lastLoginDate == null) {
      // First time logging in ever
      return user.copyWith(currentStreak: 1, lastLoginDate: now);
    }

    final lastLogin = DateTime(
      user.lastLoginDate!.year,
      user.lastLoginDate!.month,
      user.lastLoginDate!.day,
    );

    final difference = today.difference(lastLogin).inDays;

    if (difference == 0) {
      // Already logged in today. No streak change, but update timestamp.
      return user.copyWith(lastLoginDate: now);
    } else if (difference == 1) {
      // Logged in yesterday. Increment streak!
      return user.copyWith(
        currentStreak: user.currentStreak + 1,
        lastLoginDate: now,
      );
    } else {
      // Missed a day (or more).
      if (user.streakFreezes > 0) {
        // They have a Streak Freeze! Consume one and maintain streak.
        // We only consume ONE freeze per login session, even if they missed multiple days,
        // to simplify logic, but usually games consume 1 per missed day.
        // Let's assume 1 freeze protects the whole gap for simplicity, or 1 freeze = 1 day.
        // For standard gamification: 1 freeze = 1 missed day.
        if (difference - 1 <= user.streakFreezes) {
          return user.copyWith(
            streakFreezes: user.streakFreezes - (difference - 1),
            lastLoginDate: now,
            // Streak is maintained, but not incremented for missed days. Increment by 1 for today.
            currentStreak: user.currentStreak + 1,
          );
        }
      }

      // Reset streak
      return user.copyWith(currentStreak: 1, lastLoginDate: now);
    }
  }
}
