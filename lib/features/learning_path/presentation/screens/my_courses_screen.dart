import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/learning_path/data/repositories/course_repository.dart';
import 'package:lerno/core/widgets/winding_path_painter.dart';

final coursesProvider = FutureProvider<List<CourseItem>>((ref) async {
  return ref.read(courseRepositoryProvider).fetchCourses();
});

class MyCoursesScreen extends ConsumerWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textDark),
          onPressed: () {
            ref.read(audioManagerProvider).playClick();
            Navigator.pop(context);
          },
        ),
        title: const Text('My courses',
            style: TextStyle(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w900,
                fontSize: 22)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your learning track, lets start learning...',
                  style: TextStyle(color: AppTheme.textLight, fontSize: 13)),
              const SizedBox(height: 24),

              // Active course banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981), // Vibrant Green
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.3),
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
                          const Text('All about Words',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white)),
                          const SizedBox(height: 8),
                          const Text('Lorem ipsum dolor sit amet, consetetur',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  height: 1.4)),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () =>
                                ref.read(audioManagerProvider).playClick(),
                            icon: const Icon(Icons.play_arrow,
                                color: Color(0xFF10B981), size: 20),
                            label: const Text('Start',
                                style: TextStyle(
                                    color: Color(0xFF10B981),
                                    fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    SvgPicture.asset('assets/images/avatars/octopus.svg',
                        width: 80),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Winding Path Simulation using Dynamic Data
              ref.watch(coursesProvider).when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) =>
                        Center(child: Text('Failed to load courses: $err')),
                    data: (courses) {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          // Background Winding Path
                          Positioned.fill(
                            child: CustomPaint(
                              painter: WindingPathPainter(),
                            ),
                          ),
                          // Course Nodes
                          Column(
                            children: courses.asMap().entries.map((entry) {
                              final index = entry.key;
                              final course = entry.value;

                              // Determine staggered alignment
                              final alignment = (index % 2 == 0)
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight;

                              // Determine colors (cycle through green, purple, blue)
                              List<Color> colors = [
                                const Color(0xFF10B981),
                                const Color(0xFF8B5CF6),
                                const Color(0xFF3B82F6)
                              ];
                              Color nodeColor = colors[index % colors.length];

                              return _buildPathItem(
                                context,
                                ref,
                                title: course.title,
                                svgPath: course.iconAsset,
                                alignment: alignment,
                                isLocked: course.isLocked,
                                color: nodeColor,
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPathItem(BuildContext context, WidgetRef ref,
      {required String title,
      required String svgPath,
      required Alignment alignment,
      required bool isLocked,
      required Color color}) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () {
          if (isLocked) {
            ref.read(audioManagerProvider).playFail();
          } else {
            ref.read(audioManagerProvider).playSuccess();
            context.push('/game/mock');
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 60),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isLocked ? Colors.grey.shade300 : color,
                  shape: BoxShape.circle,
                  boxShadow: isLocked
                      ? []
                      : [
                          BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8)),
                          const BoxShadow(
                              color: Colors.white,
                              spreadRadius: 4,
                              blurRadius: 0),
                        ],
                ),
                child: Center(
                  child: SvgPicture.asset(svgPath,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn)),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: isLocked ? Colors.grey : AppTheme.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
