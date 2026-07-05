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
    return GestureDetector(
      onTap: () {
        ref.read(audioManagerProvider).playClick();
        context.push('/arena');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFFA855F7).withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 10))
          ],
          border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.flash_on, color: Colors.amber, size: 28),
                    ),
                    const SizedBox(width: 12),
                    const Text('SEASON 1',
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2)),
                  ],
                ),
                const SizedBox(height: 15),
                const Text('BRAIN BATTLE\nARENA',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: 1)),
                const SizedBox(height: 8),
                const Text('Ranked 1v1 Quiz Matches',
                    style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(color: Colors.white.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
                      ]
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('PLAY RANKED',
                          style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1)),
                      SizedBox(width: 8),
                      Icon(Icons.sports_esports, color: AppTheme.primaryBlue, size: 20),
                    ],
                  ),
                )
              ],
            ),
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
        margin: const EdgeInsets.only(bottom: 16),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: bgColor.withValues(alpha: 0.3), width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  color: bgColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(child: Icon(icon, color: bgColor, size: 36)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(game.title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          color: AppTheme.textDark)),
                  const SizedBox(height: 4),
                  Text(game.subtitle,
                      style: const TextStyle(color: AppTheme.textLight, fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildTag(game.difficulty, bgColor),
                      const SizedBox(width: 8),
                      _buildTag(game.estimatedTime, Colors.grey.shade600),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.stars, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text('+${game.xpReward}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      )
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
