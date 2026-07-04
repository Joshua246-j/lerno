import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/games/common/presentation/game_manager_screen.dart';
import 'package:lerno/features/games/common/presentation/widgets/countdown_timer.dart';
import '../providers/word_hunt_provider.dart';

class WordHuntScreen extends ConsumerWidget {
  const WordHuntScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameManagerScreen(
      gameTitle: 'Word Hunt',
      gameDescription:
          'Find the hidden words in the grid to earn XP and Coins!',
      onGameStart: (ctx, ref) {
        ref.read(wordHuntProvider.notifier).startGame();
      },
      gameContent: const WordHuntGameContent(),
    );
  }
}

class WordHuntGameContent extends ConsumerStatefulWidget {
  const WordHuntGameContent({super.key});

  @override
  ConsumerState<WordHuntGameContent> createState() =>
      _WordHuntGameContentState();
}

class _WordHuntGameContentState extends ConsumerState<WordHuntGameContent> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wordHuntProvider);

    // Watch for game over state to notify GameManager
    ref.listen(wordHuntProvider, (previous, next) {
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
                  const Text('Score',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text('${state.score}',
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue)),
                ],
              ),
              CountdownTimer(
                  secondsRemaining: state.timeLeft, totalSeconds: 30),
            ],
          ),
          const SizedBox(height: 40),
          const Text('Find the word:',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          Text(
            state.targetWord,
            style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: AppTheme.textDark),
          ),
          const Spacer(),
          if (state.grid.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 16,
              itemBuilder: (context, index) {
                final isSelected = state.selectedIndices.contains(index);
                return GestureDetector(
                  onTap: () {
                    ref.read(audioManagerProvider).playClick();
                    ref.read(wordHuntProvider.notifier).selectTile(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryGreen : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppTheme.modernShadow,
                      border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : Colors.grey.shade300,
                          width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      state.grid[index],
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppTheme.textDark,
                      ),
                    ),
                  ),
                );
              },
            ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
