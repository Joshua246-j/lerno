import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/widgets/mountain_background.dart';

class GameResultOverlay extends StatelessWidget {
  final bool isVictory;
  final int xpEarned;
  final int coinsEarned;
  final VoidCallback onContinue;

  const GameResultOverlay({
    super.key,
    required this.isVictory,
    required this.xpEarned,
    required this.coinsEarned,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final title = isVictory ? 'Level Complete!' : 'Try Again!';
    final color = isVictory ? AppTheme.primaryBlue : Colors.orangeAccent;
    final icon = isVictory ? Icons.star : Icons.refresh;

    return Container(
      color: color.withValues(alpha: 0.95),
      child: Stack(
        children: [
          const Positioned(
            bottom: 0, left: 0, right: 0,
            child: MountainBackground(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 100, color: Colors.white)
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .scaleXY(end: 1.2, duration: 800.ms),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ).animate().slideY(begin: 0.5).fadeIn(),
                const SizedBox(height: 24),
                if (isVictory) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRewardPill(Icons.star, '+$xpEarned XP', Colors.amber),
                      const SizedBox(width: 16),
                      _buildRewardPill(Icons.monetization_on, '+$coinsEarned Coins', Colors.yellow),
                    ],
                  ).animate(delay: 400.ms).scaleXY(begin: 0.0).fadeIn(),
                  const SizedBox(height: 50),
                ],
                ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: color,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardPill(IconData icon, String text, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
