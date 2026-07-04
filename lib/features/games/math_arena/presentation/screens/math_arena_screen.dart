import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      gameDescription: 'Solve math equations as fast as you can. Build your combo for bonus XP!',
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
  ConsumerState<MathArenaGameContent> createState() => _MathArenaGameContentState();
}

class _MathArenaGameContentState extends ConsumerState<MathArenaGameContent> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mathArenaProvider);

    // Watch for game over state to notify GameManager
    ref.listen(mathArenaProvider, (previous, next) {
      if (next.isGameOver && (previous == null || !previous.isGameOver)) {
        GameManagerScope.of(context)?.onEndGame(next.score, next.score > 0);
      }
    });

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Score', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text('${state.score}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                  if (state.combo >= 2)
                    Text('${state.combo}x Combo!', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange)),
                ],
              ),
              CountdownTimer(secondsRemaining: state.timeLeft, totalSeconds: 60),
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
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppTheme.textDark),
            ),
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
                  onPressed: () {
                    if (option == state.correctOption) {
                      ref.read(audioManagerProvider).playCorrectAnswer();
                    } else {
                      ref.read(audioManagerProvider).playWrongAnswer();
                    }
                    ref.read(mathArenaProvider.notifier).submitAnswer(option);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryBlue,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text('$option', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                );
              },
            ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
