import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/word_hunt_state.dart';

final wordHuntProvider = StateNotifierProvider<WordHuntNotifier, WordHuntState>((ref) {
  return WordHuntNotifier();
});

class WordHuntNotifier extends StateNotifier<WordHuntState> {
  WordHuntNotifier() : super(const WordHuntState(grid: [], targetWord: ''));

  Timer? _timer;
  final Random _random = Random();
  final List<String> _words = ['CAT', 'DOG', 'BIRD', 'FISH', 'APPLE', 'TREE'];

  void startGame() {
    _timer?.cancel();
    state = const WordHuntState(grid: [], targetWord: '');
    _nextWord();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft > 0) {
        state = state.copyWith(timeLeft: state.timeLeft - 1);
      } else {
        timer.cancel();
        state = state.copyWith(isGameOver: true);
      }
    });
  }

  void _nextWord() {
    final word = _words[_random.nextInt(_words.length)];
    // Simple 4x4 grid (16 tiles)
    List<String> newGrid = List.generate(16, (_) {
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      return chars[_random.nextInt(chars.length)];
    });

    // Inject target word horizontally for simplicity in this prototype
    final startIndex = _random.nextInt(16 - word.length);
    for (int i = 0; i < word.length; i++) {
      newGrid[startIndex + i] = word[i];
    }

    state = state.copyWith(
      targetWord: word,
      grid: newGrid,
      selectedIndices: [],
    );
  }

  void selectTile(int index) {
    if (state.isGameOver) return;
    
    if (state.selectedIndices.contains(index)) return; // Already selected

    final newSelected = List<int>.from(state.selectedIndices)..add(index);
    
    // Check if the selected word matches target
    String selectedWord = newSelected.map((i) => state.grid[i]).join('');
    
    if (state.targetWord.startsWith(selectedWord)) {
      if (selectedWord == state.targetWord) {
        // Complete word found!
        state = state.copyWith(
          score: state.score + 10,
          timeLeft: state.timeLeft + 5, // bonus time
        );
        _nextWord();
      } else {
        // Still typing correctly
        state = state.copyWith(selectedIndices: newSelected);
      }
    } else {
      // Wrong path, reset selection
      state = state.copyWith(selectedIndices: []);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
