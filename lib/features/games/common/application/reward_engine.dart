import 'package:flutter_riverpod/flutter_riverpod.dart';

final rewardEngineProvider = Provider<RewardEngine>((ref) {
  return RewardEngine();
});

class RewardEngine {
  RewardEngine();

  Map<String, int> calculateRewards({
    required int score,
    required int timeRemaining,
    required bool isVictory,
    required int difficultyMultiplier,
  }) {
    if (!isVictory) {
      return {'xp': 10, 'coins': 5};
    }

    const baseXp = 50;
    final timeBonus = timeRemaining * 2;
    final scoreBonus = score * 5;

    final totalXp = (baseXp + timeBonus + scoreBonus) * difficultyMultiplier;
    final totalCoins = (totalXp * 0.5).round();

    return {
      'xp': totalXp,
      'coins': totalCoins,
    };
  }
}
