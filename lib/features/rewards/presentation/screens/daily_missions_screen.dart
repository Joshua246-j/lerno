import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/daily_rewards_provider.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';

class DailyMissionsScreen extends ConsumerStatefulWidget {
  const DailyMissionsScreen({super.key});

  @override
  ConsumerState<DailyMissionsScreen> createState() =>
      _DailyMissionsScreenState();
}

class _DailyMissionsScreenState extends ConsumerState<DailyMissionsScreen> {
  @override
  Widget build(BuildContext context) {
    final rewardState = ref.watch(dailyRewardsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Daily Rewards & Missions',
            style: TextStyle(
                color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Login Track
            const Text('Daily Login Rewards',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textDark)),
            const SizedBox(height: 15),
            _buildLoginTrack(rewardState),
            const SizedBox(height: 40),

            // Daily Missions
            const Text('Daily Missions',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textDark)),
            const SizedBox(height: 15),
            ...List.generate(rewardState.dailyMissions.length, (index) {
              return _buildMissionCard(
                rewardState.dailyMissions[index],
                rewardState.missionsCompleted[index],
                index,
              )
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: 100 * index))
                  .slideX();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginTrack(DailyRewardState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final day = index + 1;
              final isPast = day < state.dayInWeek;
              final isToday = day == state.dayInWeek;
              final isClaimedToday = isToday && state.hasClaimedToday;

              Color bgColor = Colors.grey.shade200;
              Color iconColor = Colors.grey.shade400;

              if (isPast || isClaimedToday) {
                bgColor = AppTheme.pastelGreen;
                iconColor = AppTheme.primaryGreen;
              } else if (isToday) {
                bgColor = AppTheme.primaryBlue.withValues(alpha: 0.2);
                iconColor = AppTheme.primaryBlue;
              }

              return Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                      border: isToday && !isClaimedToday
                          ? Border.all(color: AppTheme.primaryBlue, width: 2)
                          : null,
                    ),
                    child: Icon(
                      Icons.check,
                      color: isPast || isClaimedToday
                          ? iconColor
                          : Colors.transparent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Day $day',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                        color:
                            isToday ? AppTheme.primaryBlue : AppTheme.textLight,
                      )),
                ],
              );
            }),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.hasClaimedToday
                  ? null
                  : () {
                      ref.read(audioManagerProvider).playSuccess();
                      ref
                          .read(dailyRewardsProvider.notifier)
                          .claimDailyReward();

                      ref
                          .read(userProfileProvider.notifier)
                          .addXpAndCoins(0, 50);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Claimed 50 Coins!'),
                          backgroundColor: AppTheme.primaryGreen,
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(
                state.hasClaimedToday ? 'Claimed' : 'Claim Daily Reward',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(String title, bool isCompleted, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? AppTheme.primaryGreen : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          if (!isCompleted)
            BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppTheme.pastelGreen
                  : AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCompleted ? Icons.check_circle : Icons.star,
              color: isCompleted ? AppTheme.primaryGreen : AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.textDark,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    )),
                const SizedBox(height: 4),
                Text('Reward: 20 XP',
                    style: TextStyle(
                      color: isCompleted ? Colors.grey : AppTheme.textLight,
                      fontSize: 13,
                    )),
              ],
            ),
          ),
          if (!isCompleted)
            ElevatedButton(
              onPressed: () {
                ref.read(audioManagerProvider).playSuccess();
                ref.read(dailyRewardsProvider.notifier).completeMission(index);

                ref.read(userProfileProvider.notifier).addXpAndCoins(20, 0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.pastelBlue,
                foregroundColor: AppTheme.primaryBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Go'),
            ),
        ],
      ),
    );
  }
}
