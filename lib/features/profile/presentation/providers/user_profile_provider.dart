import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/models/user_model.dart';
import 'package:lerno/features/auth/repositories/auth_repository.dart';

class UserProfileNotifier extends StateNotifier<UserModel?> {
  final AuthRepository _authRepository;
  
  UserProfileNotifier(this._authRepository) : super(null) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authRepository.getCurrentUser();
    state = user;
  }

  void refreshProfile() {
    _loadUser();
  }

  Future<void> addXpAndCoins(int xp, int coins) async {
    if (state != null) {
      final user = state!;
      user.stats.xp += xp;
      user.stats.coins += coins;
      
      // Level up logic (every 100 XP = 1 Level)
      user.stats.level = 1 + (user.stats.xp ~/ 100);
      
      await user.save(); // Save to Hive
      state = user; // Trigger UI rebuild
    }
  }

  Future<void> updateTrophies(int trophiesDelta) async {
    if (state != null) {
      final user = state!;
      user.stats.trophies += trophiesDelta;
      if (user.stats.trophies < 0) user.stats.trophies = 0;
      
      // Simple League logic
      if (user.stats.trophies > 500) {
        user.stats.league = 'Gold';
      } else if (user.stats.trophies > 200) {
        user.stats.league = 'Silver';
      } else {
        user.stats.league = 'Bronze';
      }

      await user.save(); // Save to Hive
      state = user;
    }
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserModel?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return UserProfileNotifier(authRepo);
});
