import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/theme/app_assets.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:lerno/features/home/presentation/providers/home_provider.dart';
import 'package:lerno/data/mock_data.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final coursesAsync = ref.watch(coursesProvider);
    final activitiesAsync = ref.watch(activitiesProvider);
    final recommendationsAsync = ref.watch(recommendationsProvider);

    if (user == null) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: Center(
            child: CircularProgressIndicator(color: AppTheme.primaryBlue)),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, ref, user),
                    const SizedBox(height: 25),
                    
                    const Text('Courses',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark)),
                    const SizedBox(height: 15),
                    _buildHeroBanner(context, ref).animate().fadeIn().slideY(begin: 0.1),
                    
                    const SizedBox(height: 30),
                    const Text('Subjects',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark)),
                    const SizedBox(height: 15),
                    coursesAsync.when(
                      data: (courses) => _buildSubjectsList(courses),
                      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue)),
                      error: (err, stack) => Text('Error: $err'),
                    ),
                    
                    const SizedBox(height: 30),
                    const Text('Activity',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark)),
                    const SizedBox(height: 15),
                    activitiesAsync.when(
                      data: (activities) => _buildActivityGrid(context, ref, activities).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue)),
                      error: (err, stack) => Text('Error: $err'),
                    ),
                    
                    const SizedBox(height: 30),
                    const Text('Recommended',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark)),
                    const SizedBox(height: 15),
                    recommendationsAsync.when(
                      data: (recommendations) => _buildRecommendationsList(recommendations),
                      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue)),
                      error: (err, stack) => Text('Error: $err'),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, dynamic user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => context.push('/profile'),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryBlue, width: 2),
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryLight,
                  child: SvgPicture.asset(
                      AppAssets.getAvatarPath(user.avatarId),
                      width: 34,
                      placeholderBuilder: (_) =>
                          const Icon(LucideIcons.user, color: AppTheme.primaryBlue)),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello ${user.displayName}',
                    style: const TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                Text('Grade ${user.stats.level}',
                    style: const TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: () {
                ref.read(audioManagerProvider).playClick();
                context.push('/achievements');
              },
              icon: const Icon(LucideIcons.trophy, color: Colors.orange, size: 20),
              label: const Text('Awards', style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.bold)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.search, color: AppTheme.textLight),
              onPressed: () {
                ref.read(audioManagerProvider).playClick();
                context.push('/search');
              },
            ),
          ],
        )
      ],
    );
  }

  Widget _buildHeroBanner(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF86EFAC),
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.modernShadow,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('All about Words',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                const SizedBox(height: 8),
                const Text('Learn to read and\nwrite words',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.2)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(audioManagerProvider).playClick();
                    context.push('/game/word_hunt');
                  },
                  icon: const Icon(LucideIcons.play, size: 16),
                  label: const Text('Start',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: SvgPicture.asset(
              'assets/svg/avatars/alien.svg',
              height: 100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsList(List<MockCourse> courses) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: course.color,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: course.color.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5))
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  top: -10,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SvgPicture.asset(course.svgAsset),
                      ),
                      const SizedBox(height: 15),
                      Text(course.title.split(' ')[0],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: (100 + (index * 100)).ms).slideX(begin: 0.2);
        },
      ),
    );
  }

  Widget _buildActivityGrid(BuildContext context, WidgetRef ref, List<MockActivity> activities) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.modernShadow,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return GestureDetector(
            onTap: () {
              ref.read(audioManagerProvider).playClick();
              try { 
                context.push(activity.route); 
              } catch(e) {
                // Route missing in prototype, ignore gracefully
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: activity.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(activity.icon, color: activity.color, size: 28),
                ),
                const SizedBox(height: 10),
                Text(
                  activity.title,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendationsList(List<MockRecommendation> recommendations) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final rec = recommendations[index];
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppTheme.modernShadow,
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(rec.svgAsset),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(rec.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppTheme.textDark)),
                      const SizedBox(height: 4),
                      Text(rec.subtitle,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textLight,
                              height: 1.2)),
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(3, (starIdx) {
                          return Icon(
                            LucideIcons.star,
                            size: 12,
                            color: starIdx < rec.stars ? Colors.orange : Colors.grey.shade300,
                          );
                        }),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.chevronRight, color: AppTheme.primaryBlue, size: 20),
                )
              ],
            ),
          ).animate().fadeIn(delay: (300 + (index * 100)).ms).slideX(begin: 0.2);
        },
      ),
    );
  }
}
