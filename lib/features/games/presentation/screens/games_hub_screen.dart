import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/core/mock/game_config.dart';

class GamesHubScreen extends ConsumerWidget {
  const GamesHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Games Hub',
            style: TextStyle(
                color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        children: [
          _buildRankedBanner(context, ref),
          const SizedBox(height: 30),
          _buildCategorySection(context, ref, 'Learning Games', 'Learning'),
          const SizedBox(height: 30),
          _buildCategorySection(context, ref, 'Brain Training', 'Brain'),
          const SizedBox(height: 30),
          _buildCategorySection(context, ref, 'Logic Puzzles', 'Logic'),
        ],
      ),
    );
  }

  Widget _buildRankedBanner(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(audioManagerProvider).playClick();
        context.push('/arena');
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primaryBlue, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: AppTheme.primaryBlue.withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          children: [
            const Icon(Icons.flash_on, color: Colors.amber, size: 50),
            const SizedBox(height: 10),
            const Text('BRAIN BATTLE ARENA',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2)),
            const SizedBox(height: 5),
            const Text('Ranked 1v1 Quiz Matches',
                style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: const Text('Play Ranked',
                  style: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
      BuildContext context, WidgetRef ref, String title, String category) {
    final games =
        GameConfig.allGames.where((g) => g.category == category).toList();
    if (games.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark)),
        const SizedBox(height: 15),
        ...games.map((g) => _buildGameCard(context, ref, g)),
      ],
    );
  }

  Widget _buildGameCard(BuildContext context, WidgetRef ref, GameInfo game) {
    final Color bgColor = game.category == 'Learning'
        ? const Color(0xFF10B981)
        : game.category == 'Brain'
            ? const Color(0xFFEC4899)
            : const Color(0xFF6366F1);
    final IconData icon = game.category == 'Learning'
        ? Icons.school
        : game.category == 'Brain'
            ? Icons.psychology
            : Icons.extension;

    return GestureDetector(
      onTap: () {
        ref.read(audioManagerProvider).playClick();
        context.push(game.route);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppTheme.modernShadow,
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: bgColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(child: Icon(icon, color: bgColor, size: 40)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(game.title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark)),
                  const SizedBox(height: 4),
                  Text(game.subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildTag(game.difficulty, bgColor),
                      const SizedBox(width: 8),
                      _buildTag(game.estimatedTime, Colors.grey),
                      const SizedBox(width: 8),
                      _buildTag('+${game.xpReward} XP', Colors.amber),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
