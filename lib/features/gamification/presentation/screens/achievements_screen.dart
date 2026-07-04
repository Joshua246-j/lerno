import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/theme/app_theme.dart';

class Achievement {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final double progress; // 0.0 to 1.0
  final bool isUnlocked;

  Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.progress,
    required this.isUnlocked,
  });
}

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  final List<Achievement> _achievements = [
    Achievement(
      title: 'First Win',
      description: 'Win your first Quiz Battle',
      icon: Icons.emoji_events,
      color: Colors.amber,
      progress: 1.0,
      isUnlocked: true,
    ),
    Achievement(
      title: 'Math Whiz',
      description: 'Score 100+ points in Math Arena',
      icon: Icons.calculate,
      color: Colors.blue,
      progress: 1.0,
      isUnlocked: true,
    ),
    Achievement(
      title: 'Vocabulary Master',
      description: 'Find 50 words in Word Hunt',
      icon: Icons.spellcheck,
      color: Colors.green,
      progress: 0.6,
      isUnlocked: false,
    ),
    Achievement(
      title: 'Flawless Victory',
      description: 'Win a Quiz Battle without any mistakes',
      icon: Icons.star,
      color: Colors.purple,
      progress: 0.0,
      isUnlocked: false,
    ),
    Achievement(
      title: 'Social Butterfly',
      description: 'Add 5 friends',
      icon: Icons.people,
      color: Colors.pink,
      progress: 0.2,
      isUnlocked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Achievements',
            style: TextStyle(
                color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textDark),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _achievements.length,
        itemBuilder: (context, index) {
          final achievement = _achievements[index];
          return _buildAchievementCard(achievement);
        },
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: achievement.isUnlocked
              ? achievement.color.withValues(alpha: 0.5)
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: achievement.isUnlocked
                  ? achievement.color.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement.icon,
              size: 32,
              color: achievement.isUnlocked ? achievement.color : Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: achievement.isUnlocked
                        ? AppTheme.textDark
                        : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: achievement.isUnlocked
                        ? AppTheme.textLight
                        : Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: achievement.progress,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            achievement.isUnlocked
                                ? achievement.color
                                : Colors.grey.shade400,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(achievement.progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: achievement.isUnlocked
                            ? achievement.color
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
