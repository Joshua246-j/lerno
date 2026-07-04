import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/learning_path/data/repositories/learning_repository.dart';
import 'package:lerno/features/learning_path/domain/models/learning_models.dart';

class LessonScreen extends ConsumerWidget {
  final String subjectId;
  final String courseId;
  final String topicId;

  const LessonScreen({super.key, required this.subjectId, required this.courseId, required this.topicId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Lesson', style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textDark),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(audioManagerProvider).playClick();
            context.pop();
          },
        ),
      ),
      body: FutureBuilder<Lesson?>(
        future: ref.read(learningRepositoryProvider).getLessonForTopic(topicId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue));
          }

          final lesson = snapshot.data;
          if (lesson == null) {
            return const Center(child: Text("Lesson content not found."));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimeTag(lesson.estimatedMinutes),
                const SizedBox(height: 16),
                Text(lesson.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
                const SizedBox(height: 24),
                
                // Illustration placeholder
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(child: Icon(Icons.menu_book, size: 80, color: AppTheme.primaryBlue)),
                ),
                
                const SizedBox(height: 30),
                Text(
                  lesson.content,
                  style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                ),
                
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.amber),
                          SizedBox(width: 8),
                          Text('Key Points', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(lesson.keyPoints, style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87)),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(audioManagerProvider).playSuccess();
                      context.pushReplacement('/subject/$subjectId/course/$courseId/topic/$topicId/quiz');
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Mark as Read & Practice', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeTag(int minutes) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Text('$minutes mins read', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}
