import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/theme/app_assets.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:lerno/features/games/common/presentation/widgets/countdown_timer.dart';
import '../providers/arena_provider.dart';
import '../../domain/models/arena_state.dart';

class ArenaScreen extends ConsumerStatefulWidget {
  const ArenaScreen({super.key});

  @override
  ConsumerState<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends ConsumerState<ArenaScreen> {
  @override
  void initState() {
    super.initState();
    // Start matchmaking as soon as the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(arenaProvider.notifier).startMatchmaking();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(arenaProvider);

    Widget body;
    switch (state.status) {
      case MatchStatus.searching:
        body = const ArenaMatchmakingView();
        break;
      case MatchStatus.vsScreen:
        body = const ArenaVsView();
        break;
      case MatchStatus.playing:
        body = const ArenaBattleView();
        break;
      case MatchStatus.finished:
        body = const ArenaResultView();
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textDark),
          onPressed: () {
            ref.read(arenaProvider.notifier).reset();
            context.pop();
          },
        ),
        title: const Text('Brain Battle Arena', style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w900)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
          child: body,
        ),
      ),
    );
  }
}

class ArenaMatchmakingView extends ConsumerWidget {
  const ArenaMatchmakingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final myAvatarId = userProfile?.avatarId.isNotEmpty == true ? userProfile!.avatarId : 'octopus';
    final myAvatar = AppAssets.getAvatarPath(myAvatarId);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Searching Arena...',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: AppTheme.primaryBlue,
                letterSpacing: 2),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 800.ms),
          const SizedBox(height: 60),
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulse
              Container(
                width: 250, height: 250,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryBlue.withValues(alpha: 0.1)),
              ).animate(onPlay: (c) => c.repeat())
                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.5, 1.5), duration: 2.seconds)
                .fadeOut(duration: 2.seconds),
              // Inner pulse
              Container(
                width: 180, height: 180,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryGreen.withValues(alpha: 0.2)),
              ).animate(onPlay: (c) => c.repeat())
                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.5, 1.5), duration: 2.seconds, delay: 1.seconds)
                .fadeOut(duration: 2.seconds, delay: 1.seconds),
              // Player avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: AppTheme.modernShadow,
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryLight,
                  child: SvgPicture.asset(myAvatar, width: 75),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          const Text('Finding worthy opponent...', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}

class ArenaVsView extends ConsumerWidget {
  const ArenaVsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(arenaProvider);
    final userProfile = ref.watch(userProfileProvider);
    final myName = userProfile?.displayName ?? 'You';
    final myAvatarId = userProfile?.avatarId.isNotEmpty == true ? userProfile!.avatarId : 'octopus';
    final myAvatar = AppAssets.getAvatarPath(myAvatarId);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFighter(myName, myAvatar, userProfile?.stats.trophies ?? 0, true).animate().slideX(begin: -1, duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 30),
          const Text('VS', style: TextStyle(fontSize: 60, fontWeight: FontWeight.w900, color: Colors.redAccent, fontStyle: FontStyle.italic))
              .animate().scale(duration: 500.ms, curve: Curves.elasticOut).shake(hz: 3, delay: 500.ms),
          const SizedBox(height: 30),
          _buildFighter(state.opponentName, state.opponentAvatar, state.opponentTrophies, false).animate().slideX(begin: 1, duration: 500.ms, curve: Curves.easeOutBack),
        ],
      ),
    );
  }

  Widget _buildFighter(String name, String avatar, int trophies, bool isPlayer) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: isPlayer ? AppTheme.primaryBlue : Colors.redAccent, width: 5),
            boxShadow: [BoxShadow(color: isPlayer ? AppTheme.primaryBlue.withValues(alpha: 0.3) : Colors.redAccent.withValues(alpha: 0.3), blurRadius: 20)],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            child: SvgPicture.asset(avatar, width: 90),
          ),
        ),
        const SizedBox(height: 15),
        Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
        const SizedBox(height: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
            const SizedBox(width: 5),
            Text('$trophies', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.grey)),
          ],
        )
      ],
    );
  }
}

class ArenaBattleView extends ConsumerWidget {
  const ArenaBattleView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(arenaProvider);
    final userProfile = ref.watch(userProfileProvider);
    final myName = userProfile?.displayName ?? 'You';
    final myAvatarId = userProfile?.avatarId.isNotEmpty == true ? userProfile!.avatarId : 'octopus';
    final myAvatar = AppAssets.getAvatarPath(myAvatarId);

    return Column(
      children: [
        // Opponent (Top)
        _buildPlayerHUD(
          name: state.opponentName,
          avatar: state.opponentAvatar,
          score: state.opponentScore,
          isOpponent: true,
        ),
        
        // Battle Field
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildQuestionCard(context, ref, state),
            ),
          ),
        ),

        // Player (Bottom)
        _buildPlayerHUD(
          name: myName,
          avatar: myAvatar,
          score: state.playerScore,
          isOpponent: false,
        ),
      ],
    );
  }

  Widget _buildPlayerHUD({required String name, required String avatar, required int score, required bool isOpponent}) {
    const maxScore = 5;
    final progress = score / maxScore;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: isOpponent ? Colors.redAccent.withValues(alpha: 0.05) : AppTheme.primaryLight.withValues(alpha: 0.3),
        border: isOpponent ? const Border(bottom: BorderSide(color: Colors.redAccent, width: 3)) : const Border(top: BorderSide(color: AppTheme.primaryBlue, width: 3)),
      ),
      child: Row(
        mainAxisAlignment: isOpponent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isOpponent) _buildAvatarItem(avatar, score, isOpponent),
          if (!isOpponent) const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: isOpponent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return Stack(
                      children: [
                        Container(
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        Container(
                          height: 14,
                          width: MediaQuery.of(context).size.width * 0.6 * value, // approximation
                          decoration: BoxDecoration(
                            color: isOpponent ? Colors.redAccent : AppTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [BoxShadow(color: (isOpponent ? Colors.redAccent : AppTheme.primaryGreen).withValues(alpha: 0.5), blurRadius: 8)],
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ],
            ),
          ),
          if (isOpponent) const SizedBox(width: 15),
          if (isOpponent) _buildAvatarItem(avatar, score, isOpponent),
        ],
      ),
    );
  }

  Widget _buildAvatarItem(String path, int score, bool isOpponent) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          key: ValueKey(score),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: isOpponent ? Colors.redAccent : AppTheme.primaryBlue, width: 3),
            boxShadow: AppTheme.modernShadow,
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: SvgPicture.asset(path, width: 48),
          ),
        ).animate().shake(hz: 4, duration: 400.ms).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 200.ms).then().scale(begin: const Offset(1.2, 1.2), end: const Offset(1, 1)),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: isOpponent ? Colors.red : AppTheme.primaryGreen, shape: BoxShape.circle),
          child: Text('$score', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        )
      ],
    );
  }

  Widget _buildQuestionCard(BuildContext context, WidgetRef ref, ArenaState state) {
    final q = state.currentQuestion;
    if (q == null) return const SizedBox();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CountdownTimer(secondsRemaining: state.secondsRemaining, totalSeconds: 10),
        const SizedBox(height: 25),
        Container(
          key: ValueKey(q.id),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 5)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(q.questionText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
              const SizedBox(height: 30),
              ...List.generate(q.options.length, (index) {
                final isSelected = state.selectedOptionIndex == index;
                final isCorrectOption = index == q.correctIndex;
                Color bgColor = Colors.white;
                Color borderColor = Colors.grey.shade300;
                Color textColor = AppTheme.textDark;

                if (state.showCorrectAnswer) {
                  if (isCorrectOption) {
                    bgColor = AppTheme.primaryGreen;
                    borderColor = AppTheme.primaryGreen;
                    textColor = Colors.white;
                  } else if (isSelected && !isCorrectOption) {
                    bgColor = Colors.redAccent;
                    borderColor = Colors.redAccent;
                    textColor = Colors.white;
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
                      ref.read(arenaProvider.notifier).submitAnswer(index);
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                      decoration: BoxDecoration(
                        color: bgColor,
                        border: Border.all(color: borderColor, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        q.options[index],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ).animate().slideX(begin: 0.1, delay: (index * 50).ms, duration: 200.ms, curve: Curves.easeOut);
              }),
            ],
          ),
        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
      ],
    );
  }
}

class ArenaResultView extends ConsumerWidget {
  const ArenaResultView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(arenaProvider);
    final res = state.matchResult;
    final isWin = state.winner == 'player';

    if (res == null) return const Center(child: CircularProgressIndicator());

    // Play appropriate sound once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isWin) {
        ref.read(audioManagerProvider).playLevelUp();
      } else {
        ref.read(audioManagerProvider).playFail();
      }
    });

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isWin ? 'VICTORY' : 'DEFEAT',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: isWin ? AppTheme.primaryBlue : Colors.red, letterSpacing: 4))
                .animate().scale(curve: Curves.elasticOut, duration: 800.ms),
            
            const SizedBox(height: 40),
            
            if (res.leaguePromoted) ...[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.purple, Colors.blue]),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.purple.withValues(alpha:0.4), blurRadius: 20)],
                ),
                child: Column(
                  children: [
                    const Text('LEAGUE PROMOTED!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 5),
                    Text(res.newLeague, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 32)),
                  ],
                ),
              ).animate().slideY(begin: 1, duration: 600.ms, curve: Curves.easeOutBack).shake(hz: 3, delay: 600.ms),
              const SizedBox(height: 40),
            ],

            _buildStatRow(Icons.emoji_events, 'Trophies', '${res.trophiesDelta > 0 ? '+' : ''}${res.trophiesDelta}', Colors.amber),
            const SizedBox(height: 20),
            _buildStatRow(Icons.star, 'XP Earned', '+${res.xpEarned}', AppTheme.primaryBlue),
            const SizedBox(height: 20),
            _buildStatRow(Icons.monetization_on, 'Coins Earned', '+${res.coinsEarned}', Colors.orange),

            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                ref.read(arenaProvider.notifier).reset();
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('Back to Games', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ).animate().fadeIn(delay: 1.seconds),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(width: 15),
        Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
      ],
    ).animate().slideX(begin: -0.2, duration: 400.ms).fadeIn();
  }
}
