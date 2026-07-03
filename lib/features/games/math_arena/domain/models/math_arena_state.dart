class MathArenaState {
  final String equation;
  final List<int> options;
  final int correctOption;
  final int score;
  final int combo;
  final int timeLeft;
  final bool isGameOver;

  const MathArenaState({
    this.equation = '',
    this.options = const [],
    this.correctOption = 0,
    this.score = 0,
    this.combo = 0,
    this.timeLeft = 60,
    this.isGameOver = false,
  });

  MathArenaState copyWith({
    String? equation,
    List<int>? options,
    int? correctOption,
    int? score,
    int? combo,
    int? timeLeft,
    bool? isGameOver,
  }) {
    return MathArenaState(
      equation: equation ?? this.equation,
      options: options ?? this.options,
      correctOption: correctOption ?? this.correctOption,
      score: score ?? this.score,
      combo: combo ?? this.combo,
      timeLeft: timeLeft ?? this.timeLeft,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }
}
