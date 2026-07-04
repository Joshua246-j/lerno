import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/games/common/application/game_session_service.dart';

enum GameState { intro, playing, paused, results }

class GameManagerScreen extends ConsumerStatefulWidget {
  final String gameTitle;
  final String gameDescription;
  final Widget gameContent;
  final bool isRanked;
  final Function(BuildContext context, WidgetRef ref)? onGameStart;
  
  const GameManagerScreen({
    super.key,
    required this.gameTitle,
    required this.gameDescription,
    required this.gameContent,
    this.isRanked = false,
    this.onGameStart,
  });

  @override
  ConsumerState<GameManagerScreen> createState() => _GameManagerScreenState();
}

class _GameManagerScreenState extends ConsumerState<GameManagerScreen> {
  GameState _currentState = GameState.intro;
  int _score = 0;
  bool _isVictory = false;

  void _startGame() {
    ref.read(audioManagerProvider).playClick();
    if (widget.onGameStart != null) {
      widget.onGameStart!(context, ref);
    }
    setState(() {
      _currentState = GameState.playing;
    });
  }

  void _pauseGame() {
    ref.read(audioManagerProvider).playClick();
    setState(() {
      _currentState = GameState.paused;
    });
  }

  void _resumeGame() {
    ref.read(audioManagerProvider).playClick();
    setState(() {
      _currentState = GameState.playing;
    });
  }

  void _endGame(int score, bool isVictory) {
    _score = score;
    _isVictory = isVictory;
    setState(() {
      _currentState = GameState.results;
    });

    final service = ref.read(gameSessionServiceProvider);
    if (widget.isRanked) {
      service.finishRankedGame(isVictory: isVictory);
    } else {
      // Basic math for xp/coins based on score
      final xp = isVictory ? score + 20 : score;
      final coins = isVictory ? (score / 10).floor() + 5 : (score / 10).floor();
      service.finishGame(xpEarned: xp, coinsEarned: coins, isVictory: isVictory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Stack(
        children: [
          // Background Gradient
          Container(decoration: const BoxDecoration(gradient: AppTheme.primaryGradient)),
          
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildBody(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              ref.read(audioManagerProvider).playClick();
              if (_currentState == GameState.playing) {
                _pauseGame();
              } else {
                context.pop();
              }
            },
          ),
          Text(
            widget.gameTitle,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (_currentState == GameState.playing)
            IconButton(
              icon: const Icon(Icons.pause, color: Colors.white),
              onPressed: _pauseGame,
            )
          else
            const SizedBox(width: 48), // Balance spacing
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentState) {
      case GameState.intro:
        return _buildIntro();
      case GameState.playing:
        // Inject endGame callback via InheritedWidget or we just pass it down if possible.
        // For this framework, we can provide the finish callback via a Provider or InheritedWidget.
        // Using a Provider `gameControllerProvider` is best, but for simplicity we wrap it.
        return GameManagerScope(
          onEndGame: _endGame,
          child: widget.gameContent,
        );
      case GameState.paused:
        return _buildPaused();
      case GameState.results:
        return _buildResults();
    }
  }

  Widget _buildIntro() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: AppTheme.modernShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sports_esports, size: 80, color: AppTheme.primaryBlue),
            const SizedBox(height: 20),
            Text(widget.gameTitle, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
            const SizedBox(height: 15),
            Text(widget.gameDescription, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('START', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaused() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: AppTheme.modernShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('PAUSED', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _resumeGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('RESUME', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                ref.read(audioManagerProvider).playClick();
                context.pop();
              },
              child: const Text('Quit Game', style: TextStyle(color: Colors.red, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: AppTheme.modernShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isVictory ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              size: 80,
              color: _isVictory ? Colors.amber : Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              _isVictory ? 'VICTORY!' : 'GOOD TRY!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: _isVictory ? AppTheme.primaryGreen : AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 20),
            Text('Score: $_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                ref.read(audioManagerProvider).playClick();
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('CONTINUE', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class GameManagerScope extends InheritedWidget {
  final Function(int score, bool isVictory) onEndGame;

  const GameManagerScope({
    super.key,
    required this.onEndGame,
    required super.child,
  });

  static GameManagerScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GameManagerScope>();
  }

  @override
  bool updateShouldNotify(GameManagerScope oldWidget) {
    return onEndGame != oldWidget.onEndGame;
  }
}
