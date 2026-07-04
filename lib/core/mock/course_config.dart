class CourseInfo {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String difficulty;
  final String estimatedTime;
  final int lessonsCount;
  final int xpReward;
  final int coinReward;
  final double progress;

  const CourseInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.difficulty,
    required this.estimatedTime,
    required this.lessonsCount,
    required this.xpReward,
    required this.coinReward,
    this.progress = 0.0,
  });
}

class CourseConfig {
  static const List<CourseInfo> allCourses = [
    CourseInfo(
      id: 'math_basics',
      title: 'Mathematics Basics',
      subtitle: 'Learn addition, subtraction, multiplication, and division.',
      category: 'Mathematics',
      difficulty: 'Easy',
      estimatedTime: '2 Hours',
      lessonsCount: 12,
      xpReward: 500,
      coinReward: 100,
      progress: 0.45, // 45% complete
    ),
    CourseInfo(
      id: 'algebra_101',
      title: 'Algebra 101',
      subtitle: 'Solve equations and understand variables.',
      category: 'Mathematics',
      difficulty: 'Medium',
      estimatedTime: '3 Hours',
      lessonsCount: 15,
      xpReward: 800,
      coinReward: 200,
    ),
    CourseInfo(
      id: 'science_nature',
      title: 'Nature & Science',
      subtitle: 'Explore the natural world and basic physics.',
      category: 'Science',
      difficulty: 'Easy',
      estimatedTime: '2.5 Hours',
      lessonsCount: 10,
      xpReward: 600,
      coinReward: 150,
      progress: 0.1,
    ),
    CourseInfo(
      id: 'space_exploration',
      title: 'Space Exploration',
      subtitle: 'Learn about planets, stars, and the universe.',
      category: 'Science',
      difficulty: 'Medium',
      estimatedTime: '4 Hours',
      lessonsCount: 20,
      xpReward: 1000,
      coinReward: 300,
    ),
    CourseInfo(
      id: 'english_grammar',
      title: 'English Grammar',
      subtitle: 'Master verbs, nouns, and sentence structure.',
      category: 'English',
      difficulty: 'Easy',
      estimatedTime: '3 Hours',
      lessonsCount: 14,
      xpReward: 700,
      coinReward: 180,
    ),
    CourseInfo(
      id: 'logic_puzzles',
      title: 'Logic & Reasoning',
      subtitle: 'Solve complex problems and improve critical thinking.',
      category: 'Logic',
      difficulty: 'Hard',
      estimatedTime: '5 Hours',
      lessonsCount: 25,
      xpReward: 1200,
      coinReward: 400,
    ),
  ];
}
