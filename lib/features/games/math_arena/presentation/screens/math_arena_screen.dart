import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/games/common/presentation/game_manager_screen.dart';
import 'package:lerno/features/games/common/presentation/widgets/countdown_timer.dart';
import '../providers/math_arena_provider.dart';

class MathArenaScreen extends ConsumerWidget {
  const MathArenaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameManagerScreen(
      gameTitle: 'Math Arena',
      gameDescription:
          'Solve math equations as fast as you can. Build your combo for bonus XP!',
      onGameStart: (ctx, ref) {
        ref.read(mathArenaProvider.notifier).startGame();
      },
      gameContent: const MathArenaGameContent(),
    );
  }
}

class MathArenaGameContent extends ConsumerStatefulWidget {
  const MathArenaGameContent({super.key});

  @override
  ConsumerState<MathArenaGameContent> createState() =>
      _MathArenaGameContentState();
}

class _MathArenaGameContentState extends ConsumerState<MathArenaGameContent> {
  Color _flashColor = Colors.transparent;

  void _flashScreen(bool isCorrect) {
    setState(() {
      _flashColor = isCorrect ? Colors.green.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3);
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _flashColor = Colors.transparent;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mathArenaProvider);

    // Watch for game over state to notify GameManager
    ref.listen(mathArenaProvider, (previous, next) {
      if (next.isGameOver && (previous == null || !previous.isGameOver)) {
        GameManagerScope.of(context)?.onEndGame(next.score, next.score > 0);
      }
    });

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: _flashColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Score',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                    Text('${state.score}',
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue)),
                    if (state.combo >= 2)
                      Text('${state.combo}x COMBO!',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.orange))
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 300.ms)
                      .tint(color: Colors.red, duration: 300.ms),
                  ],
                ),
                CountdownTimer(
                    secondsRemaining: state.timeLeft, totalSeconds: 60),
              ],
            ),
            const Spacer(),

            // The Equation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppTheme.modernShadow,
              ),
              child: Text(
                state.equation,
                key: ValueKey(state.equation), // Key forces animation on change
                style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark),
              ).animate().scale(duration: 200.ms, curve: Curves.easeOutBack),
            ),

            const Spacer(),

            // Options Grid
            if (state.options.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final option = state.options[index];
                  return ElevatedButton(
                    key: ValueKey('${state.equation}_$index'),
                    onPressed: () {
                      final isCorrect = option == state.correctOption;
                      if (isCorrect) {
                        ref.read(audioManagerProvider).playCorrectAnswer();
                      } else {
                        ref.read(audioManagerProvider).playWrongAnswer();
                      }
                      _flashScreen(isCorrect);
                      ref.read(mathArenaProvider.notifier).submitAnswer(option);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryBlue,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text('$option',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold)),
                  ).animate().scale(delay: (index * 50).ms, duration: 200.ms, curve: Curves.easeOutBack);
                },
              ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
