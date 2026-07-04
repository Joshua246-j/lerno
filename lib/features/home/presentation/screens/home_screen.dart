import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/theme/app_assets.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:lerno/features/home/presentation/widgets/hero_carousel_widget.dart';
import 'package:lerno/features/home/presentation/widgets/quick_actions_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);

    if (user == null) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: Center(
            child: CircularProgressIndicator(color: AppTheme.primaryBlue)),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, ref, user),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const HeroCarouselWidget()
                    .animate()
                    .fadeIn()
                    .slideY(begin: 0.1),
                const SizedBox(height: 30),
                const QuickActionsWidget()
                    .animate()
                    .fadeIn(delay: 100.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your Progress',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark)),
                      const SizedBox(height: 15),
                      _buildProgressCard(context, ref, user)
                          .animate()
                          .fadeIn(delay: 200.ms)
                          .slideY(begin: 0.1),
                      const SizedBox(height: 30),
                      const Text('Daily Missions',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark)),
                      const SizedBox(height: 15),
                      _buildMissionCard(
                              context, ref, 'Complete 3 Matches', '0/3', 0.0)
                          .animate()
                          .fadeIn(delay: 300.ms)
                          .slideY(begin: 0.1),
                      const SizedBox(height: 15),
                      _buildMissionCard(
                              context, ref, 'Login for 2 days', '1/2', 0.5)
                          .animate()
                          .fadeIn(delay: 400.ms)
                          .slideY(begin: 0.1),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(
      BuildContext context, WidgetRef ref, dynamic user) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.primaryBlue,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            ref.read(audioManagerProvider).playClick();
            context.push('/notifications');
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            ref.read(audioManagerProvider).playClick();
            context.push('/settings');
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.push('/profile'),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white24,
                      child: SvgPicture.asset(
                          AppAssets.getAvatarPath(user.avatarId),
                          width: 34,
                          placeholderBuilder: (_) =>
                              const Icon(Icons.person, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello, ${user.displayName}!',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            const Icon(Icons.local_fire_department,
                                color: Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text('${user.stats.streak} Day Streak',
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, WidgetRef ref, dynamic user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.modernShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Level',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('Level ${user.stats.level}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppTheme.primaryBlue)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('XP to Next Level',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('${user.stats.xp} / ${(user.stats.level * 1000)} XP',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppTheme.textDark)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: user.stats.xp / (user.stats.level * 1000),
              backgroundColor: Colors.grey.shade200,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context, WidgetRef ref, String title,
      String progressText, double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, color: Color(0xFF10B981)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Text(progressText,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey)),
        ],
      ),
    );
  }
}
