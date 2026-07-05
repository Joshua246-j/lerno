import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/gamification/data/repositories/gamification_repository.dart';
import 'package:lerno/features/games/common/application/reward_engine.dart';

class GameSessionService {
  final Ref _ref;

  GameSessionService(this._ref);

  void finishGame({
    required int xpEarned, // Kept for backwards compatibility if needed, but reward engine overrides
    required int coinsEarned,
    required bool isVictory,
  }) {
    if (isVictory) {
      _ref.read(audioManagerProvider).playSuccess();
    } else {
      _ref.read(audioManagerProvider).playFail();
    }

    final repo = _ref.read(gamificationRepositoryProvider);
    final profile = _ref.read(userProfileProvider);
    
    // Use Reward Engine to dynamically calculate
    final rewards = _ref.read(rewardEngineProvider).calculateRewards(
      score: xpEarned, 
      timeRemaining: 10, 
      isVictory: isVictory, 
      difficultyMultiplier: 1
    );

    if (profile != null) {
      repo.resolveSoloGame(profile, isWin: isVictory, score: rewards['xp'] ?? xpEarned);
      _ref.read(userProfileProvider.notifier).refreshProfile();
    }
  }
}

final gameSessionServiceProvider = Provider<GameSessionService>((ref) {
  return GameSessionService(ref);
});
