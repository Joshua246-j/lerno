class MemoryCard {
  final int id;
  final String symbol;
  final bool isFlipped;
  final bool isMatched;

  const MemoryCard({
    required this.id,
    required this.symbol,
    this.isFlipped = false,
    this.isMatched = false,
  });

  MemoryCard copyWith({
    bool? isFlipped,
    bool? isMatched,
  }) {
    return MemoryCard(
      id: id,
      symbol: symbol,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}

class MemoryMatchState {
  final List<MemoryCard> cards;
  final int moves;
  final bool isGameOver;
  final int? firstSelectedIndex;

  const MemoryMatchState({
    required this.cards,
    this.moves = 0,
    this.isGameOver = false,
    this.firstSelectedIndex,
  });

  MemoryMatchState copyWith({
    List<MemoryCard>? cards,
    int? moves,
    bool? isGameOver,
    int? firstSelectedIndex,
    bool clearFirstSelection = false,
  }) {
    return MemoryMatchState(
      cards: cards ?? this.cards,
      moves: moves ?? this.moves,
      isGameOver: isGameOver ?? this.isGameOver,
      firstSelectedIndex: clearFirstSelection ? null : (firstSelectedIndex ?? this.firstSelectedIndex),
    );
  }
}
