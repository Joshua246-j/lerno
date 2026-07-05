import 'package:flutter_riverpod/flutter_riverpod.dart';

final badgeRepositoryProvider = Provider<BadgeRepository>((ref) {
  return BadgeRepository();
});

class BadgeRepository {
  final List<Map<String, dynamic>> _badges = [
    {
      'id': 'badge_math_1',
      'title': 'Math Beginner',
      'subject': 'Mathematics',
      'assetPath': 'assets/svg/badges/math.svg',
    },
    {
      'id': 'badge_science_1',
      'title': 'Science Explorer',
      'subject': 'Science',
      'assetPath': 'assets/svg/badges/science.svg',
    },
    {
      'id': 'badge_streak_7',
      'title': '7 Day Streak',
      'subject': 'Achievement',
      'assetPath': 'assets/svg/badges/streak_7.svg',
    },
  ];

  List<Map<String, dynamic>> getAllBadges() {
    return _badges;
  }

  String resolvePath(String badgeId) {
    final match = _badges.firstWhere((b) => b['id'] == badgeId, orElse: () => _badges.first);
    return match['assetPath'] as String;
  }
}
