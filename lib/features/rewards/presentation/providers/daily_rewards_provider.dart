import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyRewardState {
  final int currentStreak;
  final bool hasClaimedToday;
  final int dayInWeek; // 1 to 7
  final List<String> dailyMissions;
  final List<bool> missionsCompleted;

  DailyRewardState({
    required this.currentStreak,
    required this.hasClaimedToday,
    required this.dayInWeek,
    required this.dailyMissions,
    required this.missionsCompleted,
  });

  DailyRewardState copyWith({
    int? currentStreak,
    bool? hasClaimedToday,
    int? dayInWeek,
    List<String>? dailyMissions,
    List<bool>? missionsCompleted,
  }) {
    return DailyRewardState(
      currentStreak: currentStreak ?? this.currentStreak,
      hasClaimedToday: hasClaimedToday ?? this.hasClaimedToday,
      dayInWeek: dayInWeek ?? this.dayInWeek,
      dailyMissions: dailyMissions ?? this.dailyMissions,
      missionsCompleted: missionsCompleted ?? this.missionsCompleted,
    );
  }
}

class DailyRewardsNotifier extends StateNotifier<DailyRewardState> {
  DailyRewardsNotifier()
      : super(DailyRewardState(
          currentStreak: 3,
          hasClaimedToday: false,
          dayInWeek: 4,
          dailyMissions: [
            'Play 3 Quiz Battles',
            'Complete 1 Math Arena',
            'Earn 50 XP'
          ],
          missionsCompleted: [false, true, false],
        ));

  void claimDailyReward() {
    if (state.hasClaimedToday) return;

    state = state.copyWith(
      hasClaimedToday: true,
      currentStreak: state.currentStreak + 1,
    );
  }

  void completeMission(int index) {
    if (index < 0 || index >= state.missionsCompleted.length) return;

    final newCompleted = List<bool>.from(state.missionsCompleted);
    newCompleted[index] = true;

    state = state.copyWith(missionsCompleted: newCompleted);
  }
}

final dailyRewardsProvider =
    StateNotifierProvider<DailyRewardsNotifier, DailyRewardState>((ref) {
  return DailyRewardsNotifier();
});
