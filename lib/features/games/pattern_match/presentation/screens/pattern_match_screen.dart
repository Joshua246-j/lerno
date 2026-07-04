import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/games/common/presentation/game_manager_screen.dart';
import '../providers/pattern_match_provider.dart';

class PatternMatchScreen extends ConsumerWidget {
  const PatternMatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameManagerScreen(
      gameTitle: 'Pattern Match',
      gameDescription:
          'Memorize and repeat the light pattern. It gets faster and longer each level!',
      onGameStart: (ctx, ref) {
        ref.read(patternMatchProvider.notifier).startGame();
      },
      gameContent: const PatternMatchGameContent(),
    );
  }
}

class PatternMatchGameContent extends ConsumerStatefulWidget {
  const PatternMatchGameContent({super.key});

  @override
  ConsumerState<PatternMatchGameContent> createState() =>
      _PatternMatchGameContentState();
}

class _PatternMatchGameContentState
    extends ConsumerState<PatternMatchGameContent> {
  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(patternMatchProvider);

    ref.listen(patternMatchProvider, (previous, next) {
      if (next.isGameOver && (previous == null || !previous.isGameOver)) {
        GameManagerScope.of(context)?.onEndGame(next.score, next.score > 50);
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Level',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text('${state.level}',
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen)),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Icon(
                index < state.lives ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: 30,
              );
            }),
          ),
          const Spacer(),
          Text(
            state.isShowingPattern ? 'Watch Carefully...' : 'Your Turn!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color:
                  state.isShowingPattern ? Colors.orange : AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 40),
          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                // In a full implementation we would animate the colors changing during the playback.
                // For now, they are static interactive buttons.
                return GestureDetector(
                  onTap: () {
                    if (!state.isShowingPattern) {
                      ref
                          .read(audioManagerProvider)
                          .playClick(); // In a real simon game, each has a specific tone
                      ref
                          .read(patternMatchProvider.notifier)
                          .onTileTapped(index);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: _colors[index].withValues(
                          alpha: state.isShowingPattern ? 0.3 : 1.0),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _colors[index].withValues(alpha: 0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
