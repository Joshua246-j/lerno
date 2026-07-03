import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lerno/features/gamification/application/gamification_engine.dart';

class XpBar extends StatelessWidget {
  final int currentXP;
  final int level;
  final GamificationEngine engine;

  const XpBar({
    super.key,
    required this.currentXP,
    required this.level,
    required this.engine,
  });

  @override
  Widget build(BuildContext context) {
    final xpForCurrent = engine.xpForCurrentLevel(level);
    final xpForNext = engine.xpForNextLevel(level);

    final currentProgress = currentXP - xpForCurrent;
    final requiredForNext = xpForNext - xpForCurrent;

    // Safety check to prevent division by zero
    final progressFraction =
        requiredForNext > 0 ? currentProgress / requiredForNext : 1.0;
    // Clamp between 0 and 1
    final clampedFraction = progressFraction.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level $level',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '$currentXP / $xpForNext XP',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            // Background bar
            Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            // Animated Foreground bar
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 16,
                  width: constraints.maxWidth * clampedFraction,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.orangeAccent, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.5),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                ).animate().scaleX(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutQuart,
                      alignment: Alignment.centerLeft,
                    );
              },
            ),
          ],
        ),
      ],
    );
  }
}
