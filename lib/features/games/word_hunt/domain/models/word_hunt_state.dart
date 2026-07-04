class WordHuntState {
  final List<String> grid;
  final String targetWord;
  final List<int> selectedIndices;
  final int score;
  final int timeLeft;
  final bool isGameOver;

  const WordHuntState({
    required this.grid,
    required this.targetWord,
    this.selectedIndices = const [],
    this.score = 0,
    this.timeLeft = 30,
    this.isGameOver = false,
  });

  WordHuntState copyWith({
    List<String>? grid,
    String? targetWord,
    List<int>? selectedIndices,
    int? score,
    int? timeLeft,
    bool? isGameOver,
  }) {
    return WordHuntState(
      grid: grid ?? this.grid,
      targetWord: targetWord ?? this.targetWord,
      selectedIndices: selectedIndices ?? this.selectedIndices,
      score: score ?? this.score,
      timeLeft: timeLeft ?? this.timeLeft,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }
}
