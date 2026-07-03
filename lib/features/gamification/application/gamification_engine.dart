import 'dart:math';
import 'package:lerno/shared/models/user_profile.dart';

class GamificationEngine {
  static const int xpConstant = 50;

  /// Calculates the user's level based on total XP
  /// Formula: Level = sqrt(TotalXP / constant) + 1
  /// Example: 0 XP = Level 1, 50 XP = Level 2, 200 XP = Level 3, 450 XP = Level 4
  int calculateLevel(int totalXP) {
    if (totalXP < 0) return 1;
    return (sqrt(totalXP / xpConstant)).floor() + 1;
  }

  /// Calculates XP required to reach the next level
  int xpForNextLevel(int currentLevel) {
    return pow(currentLevel, 2).toInt() * xpConstant;
  }

  /// Calculates XP required for the current level (to find the baseline for progress bar)
  int xpForCurrentLevel(int currentLevel) {
    if (currentLevel <= 1) return 0;
    return pow(currentLevel - 1, 2).toInt() * xpConstant;
  }

  /// Processes game completion and returns updated UserProfile
  UserProfile processGameRewards(
    UserProfile user, {
    required int xpEarned,
    required int coinsEarned,
    required int trophiesEarned,
  }) {
    final newTotalXP = user.totalXP + xpEarned;
    final newLevel = calculateLevel(newTotalXP);

    return user.copyWith(
      totalXP: newTotalXP,
      level: newLevel,
      coins: user.coins + coinsEarned,
      trophies: user.trophies + trophiesEarned,
    );
  }
}
