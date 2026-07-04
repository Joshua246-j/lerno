import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
      final xp = isVictory ? score + 20 : score;
      final coins = isVictory ? (score / 10).floor() + 5 : (score / 10).floor();
      service.finishGame(
          xpEarned: xp, coinsEarned: coins, isVictory: isVictory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Stack(
        children: [
          // Dynamic Background based on state
          Container(
            decoration: BoxDecoration(
              gradient: _currentState == GameState.intro || _currentState == GameState.results
                  ? AppTheme.primaryGradient
                  : null,
              color: _currentState == GameState.playing || _currentState == GameState.paused
                  ? AppTheme.backgroundLight
                  : null,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Stack(
                    children: [
                      if (_currentState == GameState.playing || _currentState == GameState.paused)
                        GameManagerScope(
                          onEndGame: _endGame,
                          child: widget.gameContent,
                        ).animate().fadeIn(),
                        
                      if (_currentState == GameState.paused)
                        _buildPausedOverlay(),
                        
                      if (_currentState == GameState.intro)
                        _buildIntroOverlay(),
                        
                      if (_currentState == GameState.results)
                        _buildResultsOverlay(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isDark = _currentState == GameState.intro || _currentState == GameState.results;
    final iconColor = isDark ? Colors.white : AppTheme.textDark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(LucideIcons.x, color: iconColor),
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
            style: TextStyle(
                color: iconColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (_currentState == GameState.playing)
            IconButton(
              icon: Icon(LucideIcons.pause, color: iconColor),
              onPressed: _pauseGame,
            )
          else
            const SizedBox(width: 48), // Balance spacing
        ],
      ),
    );
  }

  Widget _buildIntroOverlay() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.gamepad2,
                  size: 60, color: AppTheme.primaryBlue),
            ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 30),
            Text(widget.gameTitle,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textDark)).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 15),
            Text(widget.gameDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5))
                .animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 5,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('START',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2)),
                  SizedBox(width: 10),
                  Icon(LucideIcons.play, color: Colors.white, size: 24),
                ],
              ),
            ).animate().scale(delay: 500.ms, curve: Curves.elasticOut),
          ],
        ),
      ),
    );
  }

  Widget _buildPausedOverlay() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.black.withValues(alpha: 0.3),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(30),
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: AppTheme.modernShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.pauseCircle, size: 60, color: AppTheme.textDark),
                  const SizedBox(height: 20),
                  const Text('PAUSED',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textDark,
                          letterSpacing: 4)),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: _resumeGame,
                    icon: const Icon(LucideIcons.play, color: Colors.white),
                    label: const Text('RESUME',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () {
                      ref.read(audioManagerProvider).playClick();
                      context.pop();
                    },
                    icon: const Icon(LucideIcons.logOut, color: Colors.red),
                    label: const Text('Quit Game',
                        style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsOverlay() {
    final int targetXp = _isVictory ? _score + 20 : _score;
    final int targetCoins = _isVictory ? (_score / 10).floor() + 5 : (_score / 10).floor();

    return Center(
      child: Container(
        margin: const EdgeInsets.all(25),
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isVictory ? LucideIcons.trophy : LucideIcons.thumbsUp,
              size: 80,
              color: _isVictory ? Colors.amber : Colors.orange,
            ).animate()
              .scale(delay: 200.ms, curve: Curves.elasticOut)
              .shake(delay: 500.ms, hz: 4),
              
            const SizedBox(height: 20),
            Text(
              _isVictory ? 'VICTORY!' : 'GOOD TRY!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: _isVictory ? AppTheme.primaryGreen : Colors.orange,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
            
            const SizedBox(height: 30),
            
            // Animated Score Tracker
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.backgroundLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Game Score:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: _score.toDouble()),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, _) {
                          return Text(value.toInt().toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primaryBlue));
                        }
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAnimatedReward(LucideIcons.star, Colors.orange, 'XP', targetXp),
                      _buildAnimatedReward(LucideIcons.coins, Colors.amber, 'Coins', targetCoins),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
            
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(audioManagerProvider).playClick();
                context.pop();
              },
              icon: const Icon(LucideIcons.check, color: Colors.white),
              label: const Text('CONTINUE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 5,
              ),
            ).animate().scale(delay: 1500.ms, curve: Curves.elasticOut),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedReward(IconData icon, Color color, String label, int targetValue) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 5),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: targetValue.toDouble()),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeOutExpo,
          builder: (context, value, _) {
            return Text('+${value.toInt()} $label', 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color));
          }
        ),
      ],
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
