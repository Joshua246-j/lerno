import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/math_arena_state.dart';

final mathArenaProvider = StateNotifierProvider<MathArenaNotifier, MathArenaState>((ref) {
  return MathArenaNotifier();
});

class MathArenaNotifier extends StateNotifier<MathArenaState> {
  MathArenaNotifier() : super(const MathArenaState());

  Timer? _timer;
  final Random _random = Random();

  void startGame() {
    _timer?.cancel();
    state = const MathArenaState(score: 0, combo: 0, timeLeft: 60);
    _generateEquation();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft > 0) {
        state = state.copyWith(timeLeft: state.timeLeft - 1);
      } else {
        timer.cancel();
        state = state.copyWith(isGameOver: true);
      }
    });
  }

  void _generateEquation() {
    // Simple addition or subtraction
    bool isAddition = _random.nextBool();
    int a = _random.nextInt(20) + 1;
    int b = _random.nextInt(20) + 1;

    int correctAns;
    String eq;

    if (isAddition) {
      correctAns = a + b;
      eq = '$a + $b = ?';
    } else {
      if (a < b) {
        int temp = a;
        a = b;
        b = temp;
      }
      correctAns = a - b;
      eq = '$a - $b = ?';
    }

    Set<int> optionsSet = {correctAns};
    while (optionsSet.length < 4) {
      int offset = _random.nextInt(10) - 5;
      if (offset != 0 && correctAns + offset >= 0) {
        optionsSet.add(correctAns + offset);
      }
    }

    List<int> options = optionsSet.toList()..shuffle();

    state = state.copyWith(
      equation: eq,
      options: options,
      correctOption: correctAns,
    );
  }

  void submitAnswer(int answer) {
    if (state.isGameOver) return;

    if (answer == state.correctOption) {
      // Correct!
      state = state.copyWith(
        score: state.score + 10 + (state.combo * 2), // Combo bonus
        combo: state.combo + 1,
      );
    } else {
      // Wrong!
      state = state.copyWith(combo: 0); // Reset combo
    }

    _generateEquation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
