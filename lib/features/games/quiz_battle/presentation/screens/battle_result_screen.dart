import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import '../providers/quiz_battle_provider.dart';

import 'package:go_router/go_router.dart';
import 'package:lerno/features/games/common/application/game_session_service.dart';

class BattleResultScreen extends ConsumerStatefulWidget {
  const BattleResultScreen({super.key});

  @override
  ConsumerState<BattleResultScreen> createState() => _BattleResultScreenState();
}

class _BattleResultScreenState extends ConsumerState<BattleResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final battleState = ref.read(quizBattleProvider);
      
      ref.read(gameSessionServiceProvider).finishRankedGame(
        isVictory: battleState.winner == 'player',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final battleState = ref.watch(quizBattleProvider);
    final isWin = battleState.winner == 'player';

    return Scaffold(
      backgroundColor: isWin ? AppTheme.primaryGreen : Colors.redAccent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isWin ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                size: 120,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                isWin ? 'VICTORY!' : 'DEFEAT!',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isWin ? 'You won the battle!' : 'Better luck next time...',
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 40),

              // Score breakdown
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('You',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text('${battleState.playerScore}',
                            style: const TextStyle(
                                fontSize: 30,
                                color: AppTheme.primaryBlue,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Text('VS',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey)),
                    Column(
                      children: [
                        Text(battleState.opponentName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text('${battleState.opponentScore}',
                            style: const TextStyle(
                                fontSize: 30,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(audioManagerProvider).playClick();
                    ref.read(quizBattleProvider.notifier).reset();
                    context.pushReplacement('/matchmaking');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor:
                        isWin ? AppTheme.primaryGreen : Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Rematch',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  ref.read(audioManagerProvider).playClick();
                  ref.read(quizBattleProvider.notifier).reset();
                  context.go('/main');
                },
                child: const Text('Return to Home',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
