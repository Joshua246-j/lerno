import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import '../../domain/models/battle_state.dart';
import '../providers/quiz_battle_provider.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:lerno/features/games/common/presentation/widgets/countdown_timer.dart' as common_widgets;

class BattleArenaScreen extends ConsumerWidget {
  const BattleArenaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battleState = ref.watch(quizBattleProvider);
    final userProfile = ref.watch(userProfileProvider);

    final myName = userProfile?.displayName ?? 'Guest';
    final myAvatar = userProfile?.avatarAsset.isNotEmpty == true ? userProfile!.avatarAsset : 'assets/images/avatars/octopus.svg';

    ref.listen<BattleState>(quizBattleProvider, (previous, next) {
      if (next.status == MatchStatus.finished) {
        Navigator.pushReplacementNamed(context, '/battle_result');
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Opponent Header (Top)
            _buildPlayerHeader(
              name: battleState.opponentName,
              avatar: battleState.opponentAvatar,
              score: battleState.opponentScore,
              isOpponent: true,
            ),

            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildQuestionCard(context, ref, battleState),
                ),
              ),
            ),

            // Player Header (Bottom)
            _buildPlayerHeader(
              name: myName,
              avatar: myAvatar,
              score: battleState.playerScore,
              isOpponent: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerHeader(
      {required String name,
      required String avatar,
      required int score,
      required bool isOpponent}) {
    const maxScore = 5;
    final progress = score / maxScore;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: isOpponent
            ? Colors.redAccent.withValues(alpha: 0.1)
            : AppTheme.primaryLight,
        borderRadius: isOpponent
            ? const BorderRadius.vertical(bottom: Radius.circular(30))
            : const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment:
            isOpponent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isOpponent) _buildAvatarItem(avatar),
          if (!isOpponent) const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: isOpponent
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white,
                  color: isOpponent ? Colors.redAccent : AppTheme.primaryGreen,
                  borderRadius: BorderRadius.circular(5),
                ),
                const SizedBox(height: 5),
                Text('$score / $maxScore',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (isOpponent) const SizedBox(width: 15),
          if (isOpponent) _buildAvatarItem(avatar),
        ],
      ),
    );
  }

  Widget _buildAvatarItem(String path) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        child: SvgPicture.asset(path, width: 40),
      ),
    );
  }

  Widget _buildQuestionCard(
      BuildContext context, WidgetRef ref, BattleState state) {
    final q = state.currentQuestion;
    if (q == null) return const CircularProgressIndicator();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        common_widgets.CountdownTimer(
          secondsRemaining: state.secondsRemaining,
          totalSeconds: 10,
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
            ],
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            q.questionText,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark),
          ),
          const SizedBox(height: 30),
          ...List.generate(q.options.length, (index) {
            final isSelected = state.selectedOptionIndex == index;
            final isCorrectOption = index == q.correctIndex;

            Color bgColor = Colors.white;
            Color borderColor = Colors.grey.shade300;

            if (state.showCorrectAnswer) {
              if (isCorrectOption) {
                bgColor = AppTheme.primaryGreen.withValues(alpha: 0.2);
                borderColor = AppTheme.primaryGreen;
              } else if (isSelected && !isCorrectOption) {
                bgColor = Colors.red.withValues(alpha: 0.2);
                borderColor = Colors.red;
              }
            } else if (isSelected) {
              bgColor = AppTheme.primaryLight;
              borderColor = AppTheme.primaryBlue;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () {
                  if (state.showCorrectAnswer) return;
                  ref.read(audioManagerProvider).playClick();
                  ref.read(quizBattleProvider.notifier).submitAnswer(index);
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: bgColor,
                    border: Border.all(color: borderColor, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    q.options[index],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      ),
      ],
    );
  }
}
