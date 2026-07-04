import 'package:lerno/features/learning_path/data/repositories/course_repository.dart';

class MockData {
  static const List<CourseItem> courses = [
    CourseItem(
      id: 'c1',
      title: 'All about Words',
      description: 'Learn to read and write words',
      iconAsset: 'assets/images/games/word_puzzle.svg',
      isLocked: false,
    ),
    CourseItem(
      id: 'c2',
      title: 'Word puzzle',
      description: 'Level 1',
      iconAsset: 'assets/images/games/word_puzzle.svg',
      isLocked: false,
    ),
    CourseItem(
      id: 'c3',
      title: 'Math Game',
      description: 'Level 2',
      iconAsset: 'assets/images/games/math_game.svg',
      isLocked: true,
    ),
    CourseItem(
      id: 'c4',
      title: 'Language Arts - Learning Letters',
      description:
          'A jungle full of letters. Meet Blob and his virtual buddies.',
      iconAsset: 'assets/images/games/language_arts.svg',
      isLocked: true,
    ),
    CourseItem(
      id: 'c5',
      title: 'Learn shapes',
      description: 'Geometric figure such as a square, triangle...',
      iconAsset: 'assets/images/games/shapes.svg',
      isLocked: true,
    ),
    CourseItem(
      id: 'c6',
      title: 'Science game',
      description: 'Level 4',
      iconAsset: 'assets/images/games/science_game.svg',
      isLocked: true,
    ),
  ];

  static const int initialXP = 1250;
  static const int initialCoins = 340;
  static const int currentLevel = 12;
}
