import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/games/common/application/game_session_service.dart';

class ChessPuzzlesScreen extends ConsumerStatefulWidget {
  const ChessPuzzlesScreen({super.key});

  @override
  ConsumerState<ChessPuzzlesScreen> createState() => _ChessPuzzlesScreenState();
}

class _ChessPuzzlesScreenState extends ConsumerState<ChessPuzzlesScreen> {
  int _score = 0;
  int _puzzlesCompleted = 0;
  
  void _solvePuzzle() {
    ref.read(audioManagerProvider).playSuccess();
    setState(() {
      _score += 50;
      _puzzlesCompleted++;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Great move! +50 points'),
        backgroundColor: AppTheme.primaryGreen,
        duration: Duration(seconds: 1),
      ),
    );
    
    if (_puzzlesCompleted >= 3) {
      _finishGame();
    }
  }

  void _finishGame() {
    ref.read(gameSessionServiceProvider).finishGame(
          xpEarned: _score,
          coinsEarned: 20,
          isVictory: true,
        );

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Chess Puzzles',
            style: TextStyle(
                color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textDark),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Score: $_score',
                style: const TextStyle(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Find the winning move!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark),
            ),
            const SizedBox(height: 8),
            Text(
              'Puzzle ${_puzzlesCompleted + 1} of 3',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            
            // Mock Chess Board Area
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5))
                  ],
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                  ),
                  itemCount: 64,
                  itemBuilder: (context, index) {
                    final row = index ~/ 8;
                    final col = index % 8;
                    final isLight = (row + col) % 2 == 0;
                    return Container(
                      color: isLight ? Colors.white : Colors.grey.shade300,
                      child: Center(
                        child: index == 27 || index == 36
                            ? Icon(Icons.person, color: isLight ? Colors.black : Colors.white, size: 24)
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _solvePuzzle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Make Move (Mock)',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
