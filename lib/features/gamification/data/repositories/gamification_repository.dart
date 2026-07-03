import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/features/gamification/domain/models/gamification_models.dart';
import 'package:lerno/shared/models/user_profile.dart';
import 'package:lerno/core/providers/network_provider.dart';
import 'package:lerno/data/local/local_database_service.dart';

final gamificationRepositoryProvider = Provider((ref) {
  final isOnline = ref.watch(networkProvider);
  final localDb = ref.watch(localDatabaseProvider);
  return GamificationRepository(isOnline, localDb);
});

class GamificationRepository {
  final bool _isOnline;
  final LocalDatabaseService _localDb;

  GamificationRepository(this._isOnline, this._localDb);

  /// Fetch user's current gamification data (XP, League, Trophies)
  Future<UserProfile> fetchUserGamificationData(String userId) async {
    // If offline, attempt to get from cache
    if (!_isOnline) {
      final cached = await _localDb.getProfile();
      if (cached != null) return cached;
      // If no cache, return default mock
    }

    await Future.delayed(const Duration(milliseconds: 500));
    final profile = UserProfile(
      id: userId,
      displayName: 'AstroKid7',
      phoneNumber: '1234567890',
      totalXP: 450,
      level: 4,
      trophies: 120,
      league: 'Silver',
      streakFreezes: 1,
    );
    await _localDb.saveProfile(profile);
    return profile;
  }

  /// Syncs newly earned XP and Trophies after a game
  Future<void> syncGameResults({
    required String userId,
    required int xpEarned,
    required int trophiesEarned,
  }) async {
    if (!_isOnline) {
      // Queue it up for later!
      final action = SyncAction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'gain_xp',
        payload: {
          'userId': userId,
          'xpEarned': xpEarned,
          'trophiesEarned': trophiesEarned,
        },
        timestamp: DateTime.now(),
      );
      await _localDb.enqueueSyncAction(action);
      return;
    }

    // Simulating server sync
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// Fetch weekly leaderboard for current league
  Future<List<UserProfile>> fetchLeagueLeaderboard(String leagueName) async {
    if (!_isOnline) return [];
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      UserProfile(
          id: '1', displayName: 'Player One', phoneNumber: '', trophies: 500, league: leagueName, avatarUrl: 'assets/images/avatars/astronaut.svg'),
      UserProfile(
          id: '2', displayName: 'Player Two', phoneNumber: '', trophies: 450, league: leagueName, avatarUrl: 'assets/images/avatars/robot.svg'),
      UserProfile(
          id: '3', displayName: 'AstroKid7', phoneNumber: '', trophies: 120, league: leagueName, avatarUrl: 'assets/images/avatars/octopus.svg'),
      UserProfile(
          id: '4', displayName: 'CyberNinja', phoneNumber: '', trophies: 100, league: leagueName, avatarUrl: 'assets/images/avatars/alien.svg'),
    ];
  }

  Future<List<UserProfile>> fetchGlobalLeaderboard() async {
    if (!_isOnline) return [];
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      UserProfile(
          id: '10', displayName: 'Grandmaster Q', phoneNumber: '', trophies: 5000, league: 'Legend', avatarUrl: 'assets/images/avatars/robot.svg'),
      UserProfile(
          id: '11', displayName: 'StarLord', phoneNumber: '', trophies: 4800, league: 'Grand Champion', avatarUrl: 'assets/images/avatars/astronaut.svg'),
      UserProfile(
          id: '12', displayName: 'GalaxyBrain', phoneNumber: '', trophies: 4200, league: 'Champion', avatarUrl: 'assets/images/avatars/alien.svg'),
      UserProfile(
          id: '3', displayName: 'AstroKid7', phoneNumber: '', trophies: 120, league: 'Silver I', avatarUrl: 'assets/images/avatars/octopus.svg'),
    ];
  }

  Future<List<UserProfile>> fetchFriendsLeaderboard() async {
    if (!_isOnline) return [];
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      UserProfile(
          id: '20', displayName: 'Bestie Bob', phoneNumber: '', trophies: 800, league: 'Gold III', avatarUrl: 'assets/images/avatars/robot.svg'),
      UserProfile(
          id: '3', displayName: 'AstroKid7', phoneNumber: '', trophies: 120, league: 'Silver I', avatarUrl: 'assets/images/avatars/octopus.svg'),
      UserProfile(
          id: '21', displayName: 'Slowpoke', phoneNumber: '', trophies: 50, league: 'Bronze I', avatarUrl: 'assets/images/avatars/alien.svg'),
    ];
  }

  /// Fetch daily tasks for the user
  Future<List<TaskProgress>> fetchDailyTasks(String userId) async {
    if (!_isOnline) {
      final cached = await _localDb.getTasks();
      if (cached.isNotEmpty) return cached;
    }
    await Future.delayed(const Duration(milliseconds: 300));
    final tasks = [
      const TaskProgress(taskId: 'task_math_3', currentValue: 1),
      const TaskProgress(taskId: 'task_earn_100_xp', currentValue: 50),
      const TaskProgress(
          taskId: 'task_streak_5', currentValue: 5, isCompleted: true),
    ];
    await _localDb.saveTasks(tasks);
    return tasks;
  }
}
