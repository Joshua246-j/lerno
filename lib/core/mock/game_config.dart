class GameInfo {
  final String id;
  final String title;
  final String subtitle;
  final String route;
  final String category;
  final String difficulty;
  final String estimatedTime;
  final int xpReward;
  final int coinReward;

  const GameInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.category,
    required this.difficulty,
    required this.estimatedTime,
    required this.xpReward,
    required this.coinReward,
  });
}

class GameConfig {
  static const List<GameInfo> allGames = [
    GameInfo(
      id: 'quiz_battle',
      title: 'Ranked Quiz Battle',
      subtitle: 'Compete 1v1 and earn Trophies!',
      route: '/game/quiz_battle',
      category: 'Competitive',
      difficulty: 'Hard',
      estimatedTime: '3m',
      xpReward: 50,
      coinReward: 20,
    ),
    GameInfo(
      id: 'math_arena',
      title: 'Math Arena',
      subtitle: 'Solve math equations before time runs out.',
      route: '/game/math_arena',
      category: 'Learning',
      difficulty: 'Medium',
      estimatedTime: '5m',
      xpReward: 30,
      coinReward: 10,
    ),
    GameInfo(
      id: 'word_hunt',
      title: 'Word Hunt',
      subtitle: 'Find hidden words and expand your vocabulary.',
      route: '/game/word_hunt',
      category: 'Learning',
      difficulty: 'Easy',
      estimatedTime: '4m',
      xpReward: 25,
      coinReward: 5,
    ),
    GameInfo(
      id: 'memory_match',
      title: 'Memory Match',
      subtitle: 'Train your brain by matching hidden pairs.',
      route: '/game/memory_match',
      category: 'Brain',
      difficulty: 'Medium',
      estimatedTime: '3m',
      xpReward: 20,
      coinReward: 5,
    ),
    GameInfo(
      id: 'pattern_match',
      title: 'Pattern Match',
      subtitle: 'Identify the next shape in the sequence.',
      route: '/game/pattern_match',
      category: 'Logic',
      difficulty: 'Hard',
      estimatedTime: '5m',
      xpReward: 40,
      coinReward: 15,
    ),
    GameInfo(
      id: 'chess',
      title: 'Chess Puzzles',
      subtitle: 'Find the best move to checkmate.',
      route: '/game/chess',
      category: 'Logic',
      difficulty: 'Hard',
      estimatedTime: '10m',
      xpReward: 100,
      coinReward: 50,
    ),
  ];
}
