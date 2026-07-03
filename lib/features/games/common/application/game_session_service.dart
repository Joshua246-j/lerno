import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/features/gamification/application/gamification_engine.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/gamification/domain/models/league_system.dart';

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

    final engine = GamificationEngine();
    final profile = _ref.read(userProfileProvider);
    final updatedProfile = engine.processGameRewards(
      profile,
      xpEarned: xpEarned,
      coinsEarned: coinsEarned,
      trophiesEarned: 0,
    );

    _ref.read(userProfileProvider.notifier).updateProfile(updatedProfile);
  }

  void finishRankedGame({
    required bool isVictory,
  }) {
    if (isVictory) {
      _ref.read(audioManagerProvider).playSuccess();
    } else {
      _ref.read(audioManagerProvider).playFail();
    }

    final engine = GamificationEngine();
    final profile = _ref.read(userProfileProvider);

    final currentLeague = LeagueTier.getLeagueForTrophies(profile.trophies);
    final matchResult = LeagueCalculator.calculateRankedMatchResult(
      isVictory: isVictory,
      currentTrophies: profile.trophies,
      currentLeague: currentLeague,
    );

    final updatedProfile = engine.processGameRewards(
      profile,
      xpEarned: matchResult.xpEarned,
      coinsEarned: matchResult.coinsEarned,
      trophiesEarned: matchResult.trophiesEarned,
    ).copyWith(league: matchResult.newLeague.name);

    _ref.read(userProfileProvider.notifier).updateProfile(updatedProfile);
  }
}

final gameSessionServiceProvider = Provider<GameSessionService>((ref) {
  return GameSessionService(ref);
});
