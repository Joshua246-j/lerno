import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MockCourse {
  final String id;
  final String title;
  final String description;
  final String svgAsset;
  final Color color;
  final double progress;
  final int totalLessons;
  final int completedLessons;

  const MockCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.svgAsset,
    required this.color,
    required this.progress,
    required this.totalLessons,
    required this.completedLessons,
  });
}

class MockGame {
  final String id;
  final String title;
  final String category;
  final String svgAsset;
  final Color color;

  const MockGame({
    required this.id,
    required this.title,
    required this.category,
    required this.svgAsset,
    required this.color,
  });
}

class MockMission {
  final String id;
  final String title;
  final String progressText;
  final double progress;
  final int rewardXp;
  final int rewardCoins;
  final bool isCompleted;

  const MockMission({
    required this.id,
    required this.title,
    required this.progressText,
    required this.progress,
    required this.rewardXp,
    required this.rewardCoins,
    this.isCompleted = false,
  });
}

class MockActivity {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  const MockActivity({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class MockRecommendation {
  final String id;
  final String title;
  final String subtitle;
  final String svgAsset;
  final int stars;

  const MockRecommendation({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.svgAsset,
    required this.stars,
  });
}

class MockBanner {
  final String title;
  final String subtitle;
  final String actionText;
  final String route;
  final Color bgColor;
  final String svgAsset;

  const MockBanner({
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.route,
    required this.bgColor,
    required this.svgAsset,
  });
}

class MockData {
  static const List<MockBanner> banners = [
    MockBanner(
      title: 'Double XP Weekend!',
      subtitle: 'Earn 2x XP in all games and courses this weekend.',
      actionText: 'Play Now',
      route: '/daily_missions',
      bgColor: Color(0xFF8B5CF6),
      svgAsset: 'assets/svg/banners/banner1.svg',
    ),
    MockBanner(
      title: 'Ranked Quiz Battle',
      subtitle: 'Climb the leaderboard and earn trophies!',
      actionText: 'Compete',
      route: '/game/quiz_battle',
      bgColor: Color(0xFFF59E0B),
      svgAsset: 'assets/svg/banners/banner2.svg',
    ),
  ];

  static const List<MockCourse> courses = [
    MockCourse(
      id: 'math_101',
      title: 'Basic Addition',
      description: 'Learn to add numbers up to 20.',
      svgAsset: 'assets/svg/courses/maths.svg',
      color: Color(0xFF3B82F6),
      progress: 0.6,
      totalLessons: 10,
      completedLessons: 6,
    ),
    MockCourse(
      id: 'sci_101',
      title: 'Solar System',
      description: 'Explore the planets in our solar system.',
      svgAsset: 'assets/svg/courses/science.svg',
      color: Color(0xFF10B981),
      progress: 0.2,
      totalLessons: 5,
      completedLessons: 1,
    ),
    MockCourse(
      id: 'eng_101',
      title: 'Alphabet Fun',
      description: 'Master your ABCs with fun games.',
      svgAsset: 'assets/svg/courses/english.svg',
      color: Color(0xFF8B5CF6),
      progress: 1.0,
      totalLessons: 8,
      completedLessons: 8,
    ),
  ];

  static const List<MockGame> games = [
    MockGame(
      id: 'game_word',
      title: 'Word Puzzle',
      category: 'English',
      svgAsset: 'assets/svg/games/word_puzzle.svg',
      color: Color(0xFF6366F1),
    ),
    MockGame(
      id: 'game_math',
      title: 'Math Ninja',
      category: 'Math',
      svgAsset: 'assets/svg/games/math_game.svg',
      color: Color(0xFFF59E0B),
    ),
    MockGame(
      id: 'game_shapes',
      title: 'Shape Sorter',
      category: 'Logic',
      svgAsset: 'assets/svg/games/shapes.svg',
      color: Color(0xFFEC4899),
    ),
    MockGame(
      id: 'game_color',
      title: 'Color Splash',
      category: 'Art',
      svgAsset: 'assets/svg/games/colouring.svg',
      color: Color(0xFF14B8A6),
    ),
  ];

  static const List<MockMission> dailyMissions = [
    MockMission(
      id: 'm1',
      title: 'Complete 3 Matches',
      progressText: '1/3',
      progress: 0.33,
      rewardXp: 50,
      rewardCoins: 20,
    ),
    MockMission(
      id: 'm2',
      title: 'Login for 2 days',
      progressText: '1/2',
      progress: 0.5,
      rewardXp: 20,
      rewardCoins: 10,
    ),
    MockMission(
      id: 'm3',
      title: 'Score 100% in a Quiz',
      progressText: '0/1',
      progress: 0.0,
      rewardXp: 100,
      rewardCoins: 50,
    ),
  ];

  static const List<MockActivity> activities = [
    MockActivity(
        title: 'Games',
        icon: LucideIcons.gamepad2,
        color: Color(0xFF4AC4FA),
        route: '/games'),
    MockActivity(
        title: 'Dictionary',
        icon: LucideIcons.bookOpen,
        color: Color(0xFF8B5CF6),
        route: '/dictionary'),
    MockActivity(
        title: 'Painting',
        icon: LucideIcons.palette,
        color: Color(0xFFF59E0B),
        route: '/painting'),
    MockActivity(
        title: 'Listen',
        icon: LucideIcons.headphones,
        color: Color(0xFFEC4899),
        route: '/listen'),
    MockActivity(
        title: 'Speak',
        icon: LucideIcons.mic,
        color: Color(0xFF10B981),
        route: '/speak'),
    MockActivity(
        title: 'Write',
        icon: LucideIcons.pencil,
        color: Color(0xFFFBBF24),
        route: '/write'),
  ];

  static const List<MockRecommendation> recommendations = [
    MockRecommendation(
      id: 'r1',
      title: 'Fun with numbers',
      subtitle: 'Learn to add, subtract\nand more...',
      svgAsset: 'assets/svg/courses/maths.svg',
      stars: 3,
    ),
    MockRecommendation(
      id: 'r2',
      title: 'Spelling Bee',
      subtitle: 'Practice your spelling\nskills...',
      svgAsset: 'assets/svg/courses/english.svg',
      stars: 2,
    ),
  ];
}
