import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/games/common/presentation/widgets/game_header.dart';
import 'package:lerno/features/games/common/presentation/widgets/countdown_timer.dart';
import 'package:lerno/features/games/common/presentation/widgets/game_result_overlay.dart';
import 'package:lerno/features/games/common/application/game_session_service.dart';
import '../providers/word_hunt_provider.dart';

class WordHuntScreen extends ConsumerStatefulWidget {
  const WordHuntScreen({super.key});

  @override
  ConsumerState<WordHuntScreen> createState() => _WordHuntScreenState();
}

class _WordHuntScreenState extends ConsumerState<WordHuntScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(wordHuntProvider.notifier).startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wordHuntProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const GameHeader(title: 'Word Hunt'),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Score', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                          Text('${state.score}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                        ],
                      ),
                      CountdownTimer(secondsRemaining: state.timeLeft, totalSeconds: 30),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text('Find the word:', style: TextStyle(fontSize: 18, color: Colors.grey)),
                Text(
                  state.targetWord,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 4, color: AppTheme.textDark),
                ),
                const Spacer(),
                if (state.grid.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
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
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4))],
                              border: Border.all(color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade300, width: 2),
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
                  ),
                const Spacer(flex: 2),
              ],
            ),
            
            if (state.isGameOver)
              GameResultOverlay(
                isVictory: state.score > 0,
                xpEarned: state.score,
                coinsEarned: state.score ~/ 2,
                onContinue: () {
                  ref.read(gameSessionServiceProvider).finishGame(
                    xpEarned: state.score,
                    coinsEarned: state.score ~/ 2,
                    isVictory: state.score > 0,
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
