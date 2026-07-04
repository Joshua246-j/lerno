class PatternMatchState {
  final int score;
  final int level;
  final List<int> currentPattern;
  final List<int> userPattern;
  final bool isShowingPattern;
  final bool isGameOver;
  final int lives;

  const PatternMatchState({
    this.score = 0,
    this.level = 1,
    this.currentPattern = const [],
    this.userPattern = const [],
    this.isShowingPattern = true,
    this.isGameOver = false,
    this.lives = 3,
  });

  PatternMatchState copyWith({
    int? score,
    int? level,
    List<int>? currentPattern,
    List<int>? userPattern,
    bool? isShowingPattern,
    bool? isGameOver,
    int? lives,
  }) {
    return PatternMatchState(
      score: score ?? this.score,
      level: level ?? this.level,
      currentPattern: currentPattern ?? this.currentPattern,
      userPattern: userPattern ?? this.userPattern,
      isShowingPattern: isShowingPattern ?? this.isShowingPattern,
      isGameOver: isGameOver ?? this.isGameOver,
      lives: lives ?? this.lives,
    );
  }
}
