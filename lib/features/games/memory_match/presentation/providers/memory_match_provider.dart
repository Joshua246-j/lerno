import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/memory_match_models.dart';

final memoryMatchProvider =
    StateNotifierProvider<MemoryMatchNotifier, MemoryMatchState>((ref) {
  return MemoryMatchNotifier();
});

class MemoryMatchNotifier extends StateNotifier<MemoryMatchState> {
  MemoryMatchNotifier() : super(const MemoryMatchState(cards: []));

  bool _isProcessing = false;

  void startGame() {
    final symbols = ['A', 'B', 'C', 'D', 'E', 'F'];
    final pairs = [...symbols, ...symbols];
    pairs.shuffle();

    final cards = List.generate(
      pairs.length,
      (index) => MemoryCard(id: index, symbol: pairs[index]),
    );

    state = MemoryMatchState(cards: cards);
  }

  Future<void> flipCard(int index) async {
    if (_isProcessing || state.isGameOver || state.cards[index].isFlipped) {
      return;
    }

    var newCards = List<MemoryCard>.from(state.cards);
    newCards[index] = newCards[index].copyWith(isFlipped: true);

    if (state.firstSelectedIndex == null) {
      // First card flipped
      state = state.copyWith(
        cards: newCards,
        firstSelectedIndex: index,
        moves: state.moves + 1,
      );
    } else {
      // Second card flipped
      _isProcessing = true;
      state = state.copyWith(cards: newCards, moves: state.moves + 1);

      final firstIndex = state.firstSelectedIndex!;
      final firstCard = newCards[firstIndex];
      final secondCard = newCards[index];

      if (firstCard.symbol == secondCard.symbol) {
        // Match found
        newCards[firstIndex] = firstCard.copyWith(isMatched: true);
        newCards[index] = secondCard.copyWith(isMatched: true);

        final isGameOver = newCards.every((c) => c.isMatched);

        state = state.copyWith(
          cards: newCards,
          clearFirstSelection: true,
          isGameOver: isGameOver,
        );
        _isProcessing = false;
      } else {
        // No match, flip back after delay
        await Future.delayed(const Duration(milliseconds: 800));
        newCards = List<MemoryCard>.from(state.cards); // get latest
        newCards[firstIndex] = firstCard.copyWith(isFlipped: false);
        newCards[index] = secondCard.copyWith(isFlipped: false);

        state = state.copyWith(
          cards: newCards,
          clearFirstSelection: true,
        );
        _isProcessing = false;
      }
    }
  }
}
