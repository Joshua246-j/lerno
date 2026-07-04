import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/gamification/data/repositories/gamification_repository.dart';

class GameSessionService {
  final Ref _ref;

  GameSessionService(this._ref);

  void finishGame({
    required int xpEarned,
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

    if (profile != null) {
      repo.resolveSoloGame(profile, isWin: isVictory, score: xpEarned);
      _ref.read(userProfileProvider.notifier).refreshProfile();
    }
  }

  void finishRankedGame({
    required bool isVictory,
  }) {
    if (isVictory) {
      _ref.read(audioManagerProvider).playSuccess();
    } else {
      _ref.read(audioManagerProvider).playFail();
    }

    final repo = _ref.read(gamificationRepositoryProvider);
    final profile = _ref.read(userProfileProvider);

    if (profile != null) {
      repo.resolveRankedBattle(profile, isWin: isVictory, score: 0);
      _ref.read(userProfileProvider.notifier).refreshProfile();
    }
  }
}

final gameSessionServiceProvider = Provider<GameSessionService>((ref) {
  return GameSessionService(ref);
});
