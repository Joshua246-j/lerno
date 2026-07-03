import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/shared/models/user_profile.dart';
import 'package:lerno/core/mock/mock_data.dart';

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(_defaultProfile);

  static final UserProfile _defaultProfile = UserProfile(
    id: 'user_1',
    phoneNumber: '7723451234',
    displayName: 'Edvyin',
    avatarUrl: 'assets/images/avatars/octopus.svg',
    level: MockData.currentLevel,
    currentStreak: 4,
    trophies: 15,
    totalXP: MockData.initialXP,
    studentId: 'STU-102938',
    completedLessons: 12,
    matchHistory: [
      'Quiz Battle - Victory (+20 XP)',
      'Word Hunt - Completed (+15 XP)',
      'Math Arena - Defeat (+5 XP)',
      'Memory Match - Completed (+10 XP)',
    ],
  );

  void createAccount(String username, String avatarPath) {
    state = state.copyWith(
      displayName: username,
      avatarUrl: avatarPath,
    );
  }

  void updateProfile(UserProfile profile) {
    state = profile;
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});
