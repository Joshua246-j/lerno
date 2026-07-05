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
    final bannersAsync = ref.watch(bannersProvider);

    if (user == null) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: Center(
            child: CircularProgressIndicator(color: AppTheme.primaryBlue)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEDF2FA), // Light bluish background
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                    child: _buildHeader(context, ref, user),
                  ),
                  
                  // Courses (Replaces Banners)
                  _buildSectionTitle('Courses'),
                  bannersAsync.when(
                    data: (banners) => _buildBannersCarousel(context, ref, banners).animate().fadeIn().slideY(begin: 0.1),
                    loading: () => const SizedBox(height: 160, child: Center(child: CircularProgressIndicator())),
                    error: (err, stack) => const SizedBox(),
                  ),

                  const SizedBox(height: 20),
                  
                  // Subjects
                  _buildSectionTitle('Subjects'),
                  coursesAsync.when(
                    data: (courses) => _buildCoursesList(courses),
                    loading: () => const SizedBox(height: 160, child: Center(child: CircularProgressIndicator())),
                    error: (err, stack) => const SizedBox(),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Activity
                  _buildSectionTitle('Activity'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: activitiesAsync.when(
                      data: (activities) => _buildActivityGrid(context, ref, activities).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => const SizedBox(),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Recommended
                  _buildSectionTitle('Recommended'),
                  recommendationsAsync.when(
                    data: (recommendations) => _buildRecommendationsList(recommendations),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => const SizedBox(),
                  ),
                  
                  const SizedBox(height: 120), // Bottom padding for navbar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Text(title,
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: AppTheme.textDark)),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, dynamic user) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(LucideIcons.menu, color: AppTheme.primaryBlue, size: 28),
              onPressed: () => context.push('/settings'), 
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.mail, color: AppTheme.primaryBlue, size: 26),
                  onPressed: () => context.push('/inbox'),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.search, color: AppTheme.primaryBlue, size: 26),
                  onPressed: () => context.push('/search'),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.push('/profile'),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: SvgPicture.asset(
                              AppAssets.getAvatarPath(user.avatarId),
                              placeholderBuilder: (_) =>
                                  const Icon(LucideIcons.user, color: AppTheme.primaryBlue)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello ${user.displayName.split(" ")[0]}',
                          style: const TextStyle(
                              color: AppTheme.textDark,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5)),
                      Text('Grade ${user.stats.level}',
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
              const Column(
                children: [
                  Icon(LucideIcons.trophy, color: Colors.orange, size: 26),
                  SizedBox(height: 4),
                  Text('Awards', style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBannersCarousel(BuildContext context, WidgetRef ref, List<MockBanner> banners) {
    return SizedBox(
      height: 170,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.92),
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            decoration: BoxDecoration(
              color: banner.bgColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: banner.bgColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Stack(
              children: [
                // Background decorative circles
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: -30,
                  bottom: -30,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(banner.title,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    height: 1.1,
                                    color: Colors.white)),
                            const SizedBox(height: 6),
                            Text(banner.subtitle,
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2)),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(audioManagerProvider).playClick();
                                context.push(banner.route);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: banner.bgColor,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                elevation: 0,
                                minimumSize: const Size(0, 36),
                              ),
                              child: Text(banner.actionText,
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Transform.rotate(
                          angle: -0.1,
                          child: SvgPicture.asset(
                            banner.svgAsset,
                            height: 110,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildCoursesList(List<MockCourse> courses) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: course.color,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: course.color.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5))
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -15,
                  top: -15,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SvgPicture.asset(course.svgAsset),
                      ),
                      const SizedBox(height: 12),
                      Text(course.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              letterSpacing: -0.5,
                              color: Colors.white)),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: course.progress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: (100 + (index * 100)).ms).slideX(begin: 0.1);
        },
      ),
    );
  }

  Widget _buildActivityGrid(BuildContext context, WidgetRef ref, List<MockActivity> activities) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: AppTheme.modernShadow,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 25,
          crossAxisSpacing: 15,
          childAspectRatio: 0.75,
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
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: activity.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(activity.icon, color: activity.color, size: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  activity.title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
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
      height: 120,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final rec = recommendations[index];
          return Container(
            width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
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
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              letterSpacing: -0.5,
                              color: AppTheme.textDark)),
                      const SizedBox(height: 4),
                      Text(rec.subtitle,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textLight,
                              height: 1.2)),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(3, (starIdx) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: Icon(
                              LucideIcons.star,
                              size: 14,
                              color: starIdx < rec.stars ? Colors.orange : Colors.grey.shade200,
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.chevronRight, color: AppTheme.primaryBlue, size: 20),
                )
              ],
            ),
          ).animate().fadeIn(delay: (200 + (index * 100)).ms).slideX(begin: 0.1);
        },
      ),
    );
  }
}
