import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/games/common/presentation/widgets/game_header.dart';
import 'package:lerno/features/games/common/presentation/widgets/game_result_overlay.dart';
import 'package:lerno/features/games/common/application/game_session_service.dart';
import '../providers/memory_match_provider.dart';

class MemoryMatchScreen extends ConsumerStatefulWidget {
  const MemoryMatchScreen({super.key});

  @override
  ConsumerState<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends ConsumerState<MemoryMatchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(memoryMatchProvider.notifier).startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(memoryMatchProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const GameHeader(title: 'Memory Match'),
                const SizedBox(height: 20),
                Text('Moves: ${state.moves}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                const Spacer(),
                if (state.cards.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GridView.builder(
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
                              color: card.isFlipped || card.isMatched ? Colors.white : AppTheme.primaryBlue,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4))],
                              border: Border.all(color: card.isMatched ? AppTheme.primaryGreen : Colors.transparent, width: 3),
                            ),
                            alignment: Alignment.center,
                            child: card.isFlipped || card.isMatched
                                ? Text(
                                    card.symbol,
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: card.isMatched ? AppTheme.primaryGreen : AppTheme.textDark,
                                    ),
                                  )
                                : const Icon(Icons.help_outline, color: Colors.white54, size: 40),
                          ),
                        );
                      },
                    ),
                  ),
                const Spacer(flex: 2),
              ],
            ),
            
            if (state.isGameOver)
              GameResultOverlay(
                isVictory: true,
                xpEarned: max(10, 100 - state.moves * 2).toInt(), // fewer moves = more XP
                coinsEarned: 25,
                onContinue: () {
                  final xp = max(10, 100 - state.moves * 2).toInt();
                  ref.read(gameSessionServiceProvider).finishGame(
                    xpEarned: xp,
                    coinsEarned: 25,
                    isVictory: true,
                  );
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}
