import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/pattern_match_state.dart';

final patternMatchProvider =
    StateNotifierProvider<PatternMatchNotifier, PatternMatchState>((ref) {
  return PatternMatchNotifier();
});

class PatternMatchNotifier extends StateNotifier<PatternMatchState> {
  PatternMatchNotifier() : super(const PatternMatchState());

  final Random _random = Random();
  Timer? _playbackTimer;

  void startGame() {
    state = const PatternMatchState();
    _startNextLevel();
  }

  void _startNextLevel() {
    final newPattern = List<int>.from(state.currentPattern);
    newPattern.add(_random.nextInt(4)); // 4 possible tiles (0,1,2,3)

    state = state.copyWith(
      level: state.level + 1,
      currentPattern: newPattern,
      userPattern: [],
      isShowingPattern: true,
    );

    _playPattern();
  }

  void _playPattern() async {
    // Basic implementation of playing pattern. The UI should listen and flash buttons.
    // In this basic version, we just wait a bit based on length then hand control back.
    // A more advanced version would use an active step index.
    int delayMs = 1000 + (state.currentPattern.length * 600);
    _playbackTimer = Timer(Duration(milliseconds: delayMs), () {
      if (mounted) {
        state = state.copyWith(isShowingPattern: false);
      }
    });
  }

  void onTileTapped(int index) {
    if (state.isShowingPattern || state.isGameOver) return;

    final newUserPattern = List<int>.from(state.userPattern)..add(index);
    state = state.copyWith(userPattern: newUserPattern);

    // Check if the input so far matches
    for (int i = 0; i < newUserPattern.length; i++) {
      if (newUserPattern[i] != state.currentPattern[i]) {
        // Mistake!
        final newLives = state.lives - 1;
        if (newLives <= 0) {
          state = state.copyWith(lives: 0, isGameOver: true);
        } else {
          state = state.copyWith(
            lives: newLives,
            userPattern: [],
            isShowingPattern: true,
          );
          _playPattern();
        }
        return;
      }
    }

    // Success so far. Check if level is complete
    if (newUserPattern.length == state.currentPattern.length) {
      state = state.copyWith(score: state.score + (state.level * 10));
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _startNextLevel();
        }
      });
    }
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }
}
