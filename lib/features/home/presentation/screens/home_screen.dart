import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:lerno/core/providers/network_provider.dart';
import 'package:lerno/features/learning_path/presentation/screens/my_courses_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final userName = profile.displayName;
    final isOnline = ref.watch(networkProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isOnline)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.wifi_off, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Offline Mode - Sync paused',
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ).animate().slideY().fadeIn(),

              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4)),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: AppTheme.pastelPurple,
                          radius: 24,
                          child: SvgPicture.asset(
                            profile.avatarUrl.isNotEmpty ? profile.avatarUrl : 'assets/images/avatars/astronaut.svg',
                            width: 35,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello',
                            style: TextStyle(
                                color: AppTheme.textLight,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: AppTheme.textDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      ref.read(audioManagerProvider).playClick();
                      if (context.mounted) {
                        context.push('/achievements');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.emoji_events,
                              color: Color(0xFFFBBF24), size: 20),
                          const SizedBox(width: 6),
                          Text(
                            'Awards',
                            style: TextStyle(
                                color: AppTheme.textDark.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w800,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ).animate().fadeIn().slideX(),
              const SizedBox(height: 35),

              // Courses Section
              const Text('Courses',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark)),
              const SizedBox(height: 15),
              ref.watch(coursesProvider).when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (courses) {
                  final activeCourse = courses.first;
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 8))
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(activeCourse.title,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.textDark)),
                              const SizedBox(height: 8),
                              Text(activeCourse.description,
                                  style: const TextStyle(
                                      color: AppTheme.textLight,
                                      fontSize: 13,
                                      height: 1.4)),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  ref.read(audioManagerProvider).playClick();
                                  if (context.mounted) {
                                    context.push('/my_courses');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryBlue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  elevation: 4,
                                  shadowColor:
                                      AppTheme.primaryBlue.withValues(alpha: 0.4),
                                ),
                                child: const Text('Start',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ).animate().scale(delay: 300.ms),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          width: 80,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppTheme.pastelGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                              child: Icon(Icons.auto_stories,
                                  color: Colors.green,
                                  size: 40)),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2);
                },
              ),

              const SizedBox(height: 35),

              // Subjects
              const Text('Subjects',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark)),
              const SizedBox(height: 15),
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  children: [
                    _buildSubjectCard(
                            context, ref, 'maths', 'Maths', AppTheme.pastelBlue)
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .slideX(),
                    _buildSubjectCard(context, ref, 'science', 'Science',
                            AppTheme.pastelPurple)
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideX(),
                    _buildSubjectCard(context, ref, 'english', 'English',
                            AppTheme.pastelGreen)
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .slideX(),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // Activity
              const Text('Activity',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark)),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 2.2,
                  children: [
                    _buildActivityBtn(context, ref, 'Games', '/my_courses')
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .scale(),
                    _buildActivityBtn(context, ref, 'Dictionary', '/leaderboard')
                        .animate()
                        .fadeIn(delay: 350.ms)
                        .scale(),
                    _buildActivityBtn(context, ref, 'Painting', '/game/painting')
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .scale(),
                    _buildActivityBtn(context, ref, 'Listen', '/game/listen')
                        .animate()
                        .fadeIn(delay: 450.ms)
                        .scale(),
                    _buildActivityBtn(context, ref, 'Speak', '/game/speak')
                        .animate()
                        .fadeIn(delay: 500.ms)
                        .scale(),
                    _buildActivityBtn(context, ref, 'Write', '/game/write')
                        .animate()
                        .fadeIn(delay: 550.ms)
                        .scale(),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // Recommended
              const Text('Recommended',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark)),
              const SizedBox(height: 15),
              _buildRecommendedCard(context, ref, "Lorem ipsum dolor sit amet",
                      const Color(0xFFFBBF24))
                  .animate()
                  .fadeIn(delay: 600.ms)
                  .slideY(begin: 0.2),
              const SizedBox(height: 15),
              _buildRecommendedCard(context, ref, "Consetetur sadipscing elitr",
                      const Color(0xFFF87171))
                  .animate()
                  .fadeIn(delay: 700.ms)
                  .slideY(begin: 0.2),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, WidgetRef ref, String svgName,
      String title, Color bgColor) {
    return GestureDetector(
      onTap: () {
        ref.read(audioManagerProvider).playClick();
        if (context.mounted) {
          context.push('/my_courses');
        }
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset('assets/images/subjects/$svgName.svg',
                    width: 25,
                    height: 25,
                    placeholderBuilder: (context) =>
                        const Icon(Icons.book, color: AppTheme.primaryBlue)),
              ),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: AppTheme.primaryBlue)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityBtn(BuildContext context, WidgetRef ref, String title, String route) {
    return InkWell(
      onTap: () {
        ref.read(audioManagerProvider).playClick();
        if (context.mounted) {
          context.push(route);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: AppTheme.primaryBlue.withValues(alpha: 0.4), width: 1.5),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Text(title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue)),
      ),
    );
  }

  Widget _buildRecommendedCard(
      BuildContext context, WidgetRef ref, String title, Color iconColor) {
    return GestureDetector(
      onTap: () {
        ref.read(audioManagerProvider).playClick();
        if (context.mounted) {
          context.push('/my_courses');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 8))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: AppTheme.textDark)),
                  const SizedBox(height: 4),
                  const Text("Lorem ipsum dolor",
                      style: TextStyle(color: AppTheme.textLight, fontSize: 12)),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4))
                ],
              ),
              child: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
