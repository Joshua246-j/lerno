import 'package:flutter_riverpod/flutter_riverpod.dart';

final courseRepositoryProvider = Provider((ref) {
  return CourseRepository();
});

class CourseItem {
  final String id;
  final String title;
  final String description;
  final String iconAsset;
  final bool isLocked;

  const CourseItem({
    required this.id,
    required this.title,
    required this.description,
    required this.iconAsset,
    this.isLocked = false,
  });
}

class CourseRepository {
  CourseRepository();

  Future<List<CourseItem>> fetchCourses() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    return const [
      CourseItem(
        id: 'quiz_battle',
        title: 'Quiz Battle',
        description: 'Multiplayer challenge!',
        iconAsset: 'assets/images/games/colouring.svg',
        isLocked: false,
      ),
      CourseItem(
        id: 'word_hunt',
        title: 'Word Hunt',
        description: 'Find hidden words',
        iconAsset: 'assets/images/games/word_puzzle.svg',
        isLocked: false,
      ),
      CourseItem(
        id: 'memory_match',
        title: 'Memory Match',
        description: 'Train your brain',
        iconAsset: 'assets/images/games/shapes.svg',
        isLocked: false,
      ),
      CourseItem(
        id: 'math_arena',
        title: 'Math Arena',
        description: 'Solve equations fast',
        iconAsset: 'assets/images/games/math_game.svg',
        isLocked: false,
      ),
      CourseItem(
        id: 'chess',
        title: 'Chess Master',
        description: 'Learn strategies',
        iconAsset: 'assets/images/games/math_game.svg',
        isLocked: false,
      ),
    ];
  }
}
