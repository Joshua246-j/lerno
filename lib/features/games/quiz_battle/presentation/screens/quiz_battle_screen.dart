import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/games/common/presentation/game_manager_screen.dart';
import '../../domain/models/battle_state.dart';
import '../providers/quiz_battle_provider.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:lerno/features/games/common/presentation/widgets/countdown_timer.dart'
    as common_widgets;
import 'package:lerno/core/theme/app_assets.dart';

class QuizBattleScreen extends ConsumerWidget {
  const QuizBattleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameManagerScreen(
      gameTitle: 'Ranked Quiz Battle',
      gameDescription:
          'Compete against other players in real-time to earn League Trophies!',
      onGameStart: (ctx, ref) {
        ref.read(quizBattleProvider.notifier).startMatchmaking();
      },
      isRanked: true,
      gameContent: const QuizBattleContent(),
    );
  }
}

class QuizBattleContent extends ConsumerStatefulWidget {
  const QuizBattleContent({super.key});

  @override
  ConsumerState<QuizBattleContent> createState() => _QuizBattleContentState();
}

class _QuizBattleContentState extends ConsumerState<QuizBattleContent> {
  @override
  Widget build(BuildContext context) {
    final battleState = ref.watch(quizBattleProvider);

    ref.listen<BattleState>(quizBattleProvider, (previous, next) {
      if (next.status == MatchStatus.finished &&
          (previous == null || previous.status != MatchStatus.finished)) {
        final isWin = next.winner == 'player';
        GameManagerScope.of(context)?.onEndGame(isWin ? 100 : 20, isWin);
        // GameManager calls finishRankedGame because isRanked is true on the wrapper.
      }
    });

    if (battleState.status == MatchStatus.searching) {
      return const MatchmakingView();
    } else if (battleState.status == MatchStatus.playing ||
        battleState.status == MatchStatus.finished) {
      return const BattleArenaView();
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class MatchmakingView extends ConsumerWidget {
  const MatchmakingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final myAvatarId = userProfile?.avatarId.isNotEmpty == true
        ? userProfile!.avatarId
        : 'octopus';
    final myAvatar = AppAssets.getAvatarPath(myAvatarId);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Searching for Opponent...',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppTheme.primaryBlue,
                letterSpacing: 2),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true)).fadeIn(duration: 800.ms),
          const SizedBox(height: 50),
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer radar pulse
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                ),
              ).animate(onPlay: (controller) => controller.repeat())
                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.5, 1.5), duration: 2.seconds)
                .fadeOut(duration: 2.seconds),
                
              // Inner radar pulse
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                ),
              ).animate(onPlay: (controller) => controller.repeat())
                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.5, 1.5), duration: 2.seconds, delay: 1.seconds)
                .fadeOut(duration: 2.seconds, delay: 1.seconds),
                
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: SvgPicture.asset(myAvatar, width: 70),
              ),
              
              // Scanning line
              Container(
                width: 100,
                height: 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, AppTheme.primaryBlue, Colors.transparent],
                  )
                ),
              ).animate(onPlay: (controller) => controller.repeat())
               .rotate(duration: 2.seconds)
            ],
          ),
        ],
      ),
    );
  }
}

class BattleArenaView extends ConsumerWidget {
  const BattleArenaView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battleState = ref.watch(quizBattleProvider);
    final userProfile = ref.watch(userProfileProvider);

    final myName = userProfile?.displayName ?? 'Guest';
    final myAvatarId = userProfile?.avatarId.isNotEmpty == true
        ? userProfile!.avatarId
        : 'octopus';
    final myAvatar = AppAssets.getAvatarPath(myAvatarId);

    return Column(
      children: [
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
        _buildPlayerHeader(
          name: myName,
          avatar: myAvatar,
          score: battleState.playerScore,
          isOpponent: false,
        ),
      ],
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
          if (!isOpponent) _buildAvatarItem(avatar, score),
          if (!isOpponent) const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: isOpponent
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 18)),
                const SizedBox(height: 5),
                // Animated Progress Bar
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 12,
                      backgroundColor: Colors.white,
                      color: isOpponent ? Colors.redAccent : AppTheme.primaryGreen,
                      borderRadius: BorderRadius.circular(6),
                    );
                  }
                ),
                const SizedBox(height: 5),
                Text('$score / $maxScore',
                    key: ValueKey(score), // forces animation on change
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold))
                    .animate().scale(duration: 200.ms).tint(color: isOpponent ? Colors.red : AppTheme.primaryGreen),
              ],
            ),
          ),
          if (isOpponent) const SizedBox(width: 15),
          if (isOpponent) _buildAvatarItem(avatar, score),
        ],
      ),
    );
  }

  Widget _buildAvatarItem(String path, int score) {
    return Container(
      key: ValueKey(score), // Animates when score updates
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.white,
        child: SvgPicture.asset(path, width: 45),
      ),
    ).animate().shake(hz: 4, duration: 400.ms).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 200.ms).then().scale(begin: const Offset(1.2, 1.2), end: const Offset(1, 1));
  }

  Widget _buildQuestionCard(
      BuildContext context, WidgetRef ref, BattleState state) {
    final q = state.currentQuestion;
    if (q == null) return const SizedBox();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        common_widgets.CountdownTimer(
          secondsRemaining: state.secondsRemaining,
          totalSeconds: 10,
        ),
        const SizedBox(height: 20),
        Container(
          key: ValueKey(q.questionText), // Animate new questions sliding in
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: AppTheme.modernShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                q.questionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
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
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: () {
                      if (state.showCorrectAnswer) return;
                      ref.read(audioManagerProvider).playClick();
                      ref.read(quizBattleProvider.notifier).submitAnswer(index);
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 20),
                      decoration: BoxDecoration(
                        color: bgColor,
                        border: Border.all(color: borderColor, width: 2),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: isSelected ? [BoxShadow(color: borderColor.withValues(alpha:0.3), blurRadius: 10)] : [],
                      ),
                      child: Text(
                        q.options[index],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? AppTheme.primaryBlue : AppTheme.textDark),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ).animate().slideX(begin: 0.2, delay: (index * 100).ms, duration: 300.ms, curve: Curves.easeOutBack);
              }),
            ],
          ),
        ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
      ],
    );
  }
}
