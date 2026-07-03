import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/providers/network_provider.dart';
import 'package:lerno/data/local/local_database_service.dart';
import 'package:lerno/features/gamification/data/repositories/gamification_repository.dart';

final syncServiceProvider = Provider((ref) {
  final networkIsOnline = ref.watch(networkProvider);
  final localDb = ref.watch(localDatabaseProvider);
  // Need to use read for repository to avoid circular dependency issues during build
  // in a real app, use ref.watch carefully
  final repository = ref.watch(gamificationRepositoryProvider);

  return SyncService(
    isOnline: networkIsOnline,
    localDb: localDb,
    repository: repository,
  );
});

class SyncService {
  final bool isOnline;
  final LocalDatabaseService localDb;
  final GamificationRepository repository;

  SyncService({
    required this.isOnline,
    required this.localDb,
    required this.repository,
  });

  /// Call this when the app comes back online
  Future<void> syncPendingActions() async {
    if (!isOnline) return;

    final queue = await localDb.getSyncQueue();
    if (queue.isEmpty) return;

    debugPrint('Syncing ${queue.length} actions to server...');

    // Simulate pushing queue to server
    for (final action in queue) {
      debugPrint('Pushing action: ${action.type}');
      if (action.type == 'gain_xp') {
        // await repository.syncGameResults(
        //     userId: action.payload['userId'],
        //     xpEarned: action.payload['xpEarned'],
        //     trophiesEarned: action.payload['trophiesEarned']);
      }
    }

    await localDb.clearSyncQueue();
    debugPrint('Sync complete!');
  }
}
