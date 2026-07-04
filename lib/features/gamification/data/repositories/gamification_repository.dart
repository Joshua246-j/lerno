import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/features/gamification/domain/models/gamification_models.dart';
import 'package:lerno/core/models/user_model.dart';
import 'package:lerno/core/models/gamification_stats.dart';

final gamificationRepositoryProvider = Provider((ref) {
  return GamificationRepository();
});

class GamificationRepository {
  /// Resolves a Solo Mini-game match. Awards XP and Coins ONLY. Does NOT affect Trophies.
  UserModel resolveSoloGame(UserModel user,
      {required bool isWin, required int score}) {
    final xpEarned = isWin ? 20 + (score ~/ 10) : 5;
    final coinsEarned = isWin ? 10 + (score ~/ 20) : 2;

    user.stats.xp += xpEarned;
    user.stats.coins += coinsEarned;
    user.stats.level = 1 + (user.stats.xp ~/ 100);

    user.save();
    return user;
  }

  /// Resolves a Ranked Quiz Battle. Awards XP, Coins, and changes Trophies/League.
  UserModel resolveRankedBattle(UserModel user,
      {required bool isWin, required int score}) {
    final xpEarned = isWin ? 30 : 10;
    final coinsEarned = isWin ? 15 : 5;
    final trophiesDelta = isWin ? 25 : -15;

    user.stats.xp += xpEarned;
    user.stats.coins += coinsEarned;
    user.stats.level = 1 + (user.stats.xp ~/ 100);

    user.stats.trophies += trophiesDelta;
    if (user.stats.trophies < 0) user.stats.trophies = 0;

    // League thresholds
    if (user.stats.trophies > 1000) {
      user.stats.league = 'Legend';
    } else if (user.stats.trophies > 500) {
      user.stats.league = 'Gold';
    } else if (user.stats.trophies > 200) {
      user.stats.league = 'Silver';
    } else {
      user.stats.league = 'Bronze';
    }

    user.save();
    return user;
  }

  Future<List<UserModel>> fetchLeagueLeaderboard(String leagueName) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      _createMockUser('1', 'Player One', 500, leagueName,
          'assets/svg/avatars/starter/astronaut.svg'),
      _createMockUser('2', 'Player Two', 450, leagueName,
          'assets/svg/avatars/starter/robot.svg'),
      _createMockUser('3', 'AstroKid7', 120, leagueName,
          'assets/svg/avatars/starter/octopus.svg'),
      _createMockUser('4', 'CyberNinja', 100, leagueName,
          'assets/svg/avatars/shop/alien.svg'),
    ];
  }

  Future<List<UserModel>> fetchGlobalLeaderboard() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      _createMockUser('10', 'Grandmaster Q', 5000, 'Legend',
          'assets/svg/avatars/starter/robot.svg'),
      _createMockUser('11', 'StarLord', 4800, 'Grand Champion',
          'assets/svg/avatars/starter/astronaut.svg'),
      _createMockUser('12', 'GalaxyBrain', 4200, 'Champion',
          'assets/svg/avatars/shop/alien.svg'),
      _createMockUser('3', 'AstroKid7', 120, 'Silver I',
          'assets/svg/avatars/starter/octopus.svg'),
    ];
  }

  Future<List<UserModel>> fetchFriendsLeaderboard() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      _createMockUser('20', 'Bestie Bob', 800, 'Gold III',
          'assets/svg/avatars/starter/robot.svg'),
      _createMockUser('3', 'AstroKid7', 120, 'Silver I',
          'assets/svg/avatars/starter/octopus.svg'),
      _createMockUser('21', 'Slowpoke', 50, 'Bronze I',
          'assets/svg/avatars/shop/alien.svg'),
    ];
  }

  UserModel _createMockUser(
      String phone, String name, int trophies, String league, String avatar) {
    return UserModel(
      phoneNumber: phone,
      displayName: name,
      age: 10,
      avatarId: avatar,
      stats: GamificationStats(trophies: trophies, league: league),
    );
  }

  Future<List<TaskProgress>> fetchDailyTasks(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const TaskProgress(taskId: 'task_math_3', currentValue: 1),
      const TaskProgress(taskId: 'task_earn_100_xp', currentValue: 50),
      const TaskProgress(
          taskId: 'task_streak_5', currentValue: 5, isCompleted: true),
    ];
  }
}
