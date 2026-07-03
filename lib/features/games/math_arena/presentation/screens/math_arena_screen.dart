import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/games/common/presentation/widgets/game_header.dart';
import 'package:lerno/features/games/common/presentation/widgets/countdown_timer.dart';
import 'package:lerno/features/games/common/presentation/widgets/game_result_overlay.dart';
import 'package:lerno/features/games/common/application/game_session_service.dart';
import '../providers/math_arena_provider.dart';

class MathArenaScreen extends ConsumerStatefulWidget {
  const MathArenaScreen({super.key});

  @override
  ConsumerState<MathArenaScreen> createState() => _MathArenaScreenState();
}

class _MathArenaScreenState extends ConsumerState<MathArenaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mathArenaProvider.notifier).startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mathArenaProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFEF2F2), // Light red/pink bg
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const GameHeader(title: 'Math Arena'),
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
                          if (state.combo >= 2)
                            Text('${state.combo}x Combo!', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange)),
                        ],
                      ),
                      CountdownTimer(secondsRemaining: state.timeLeft, totalSeconds: 60),
                    ],
                  ),
                ),
                const Spacer(),
                
                // The Equation
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                  ),
                  child: Text(
                    state.equation,
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                  ),
                ),
                
                const Spacer(),
                
                // Options Grid
                if (state.options.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
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
                              ref.read(audioManagerProvider).playSuccess();
                            } else {
                              ref.read(audioManagerProvider).playFail();
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
                  ),
                const Spacer(flex: 2),
              ],
            ),
            
            if (state.isGameOver)
              GameResultOverlay(
                isVictory: state.score > 0,
                xpEarned: state.score,
                coinsEarned: state.score ~/ 3,
                onContinue: () {
                  ref.read(gameSessionServiceProvider).finishGame(
                    xpEarned: state.score,
                    coinsEarned: state.score ~/ 3,
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
