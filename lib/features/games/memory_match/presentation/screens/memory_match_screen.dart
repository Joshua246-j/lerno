import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/games/common/presentation/game_manager_screen.dart';
import '../providers/memory_match_provider.dart';

class MemoryMatchScreen extends ConsumerWidget {
  const MemoryMatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameManagerScreen(
      gameTitle: 'Memory Match',
      gameDescription:
          'Match all the pairs with the fewest moves possible to earn maximum XP!',
      onGameStart: (ctx, ref) {
        ref.read(memoryMatchProvider.notifier).startGame();
      },
      gameContent: const MemoryMatchGameContent(),
    );
  }
}

class MemoryMatchGameContent extends ConsumerStatefulWidget {
  const MemoryMatchGameContent({super.key});

  @override
  ConsumerState<MemoryMatchGameContent> createState() =>
      _MemoryMatchGameContentState();
}

class _MemoryMatchGameContentState
    extends ConsumerState<MemoryMatchGameContent> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(memoryMatchProvider);

    // Watch for game over state to notify GameManager
    ref.listen(memoryMatchProvider, (previous, next) {
      if (next.isGameOver && (previous == null || !previous.isGameOver)) {
        final score = max(10, 100 - next.moves * 2).toInt();
        GameManagerScope.of(context)?.onEndGame(score, true);
      }
    });

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text('Moves: ${state.moves}',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue)),
          const Spacer(),
          if (state.cards.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: state.cards.length,
              itemBuilder: (context, index) {
                final card = state.cards[index];
                return GestureDetector(
                  onTap: () {
                    if (!card.isFlipped && !card.isMatched) {
                      ref.read(audioManagerProvider).playClick();
                      ref.read(memoryMatchProvider.notifier).flipCard(index);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: card.isFlipped || card.isMatched
                          ? Colors.white
                          : AppTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppTheme.modernShadow,
                      border: Border.all(
                          color: card.isMatched
                              ? AppTheme.primaryGreen
                              : Colors.transparent,
                          width: 3),
                    ),
                    alignment: Alignment.center,
                    child: card.isFlipped || card.isMatched
                        ? Text(
                            card.symbol,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: card.isMatched
                                  ? AppTheme.primaryGreen
                                  : AppTheme.textDark,
                            ),
                          )
                        : const Icon(Icons.help_outline,
                            color: Colors.white54, size: 40),
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
