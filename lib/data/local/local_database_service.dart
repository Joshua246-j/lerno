import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/shared/models/user_profile.dart';
import 'package:lerno/features/gamification/domain/models/gamification_models.dart';

final localDatabaseProvider = Provider((ref) => LocalDatabaseService());

/// Represents an action that happened while offline
class SyncAction {
  final String id;
  final String type; // e.g., 'gain_xp', 'complete_task'
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  SyncAction({
    required this.id,
    required this.type,
    required this.payload,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'payload': payload,
        'timestamp': timestamp.toIso8601String(),
      };
}

/// Mock Local Database for prototyping Offline-First behavior
class LocalDatabaseService {
  UserProfile? _cachedProfile;
  List<TaskProgress> _cachedTasks = [];
  final List<SyncAction> _syncQueue = [];

  // Simulate local latency
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 50));

  Future<UserProfile?> getProfile() async {
    await _delay();
    return _cachedProfile;
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _delay();
    _cachedProfile = profile;
  }

  Future<List<TaskProgress>> getTasks() async {
    await _delay();
    return _cachedTasks;
  }

  Future<void> saveTasks(List<TaskProgress> tasks) async {
    await _delay();
    _cachedTasks = tasks;
  }

  Future<void> enqueueSyncAction(SyncAction action) async {
    await _delay();
    _syncQueue.add(action);
  }

  Future<List<SyncAction>> getSyncQueue() async {
    await _delay();
    return List.unmodifiable(_syncQueue);
  }

  Future<void> clearSyncQueue() async {
    await _delay();
    _syncQueue.clear();
  }
}
