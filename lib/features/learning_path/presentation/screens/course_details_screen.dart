import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/learning_path/data/repositories/learning_repository.dart';
import 'package:lerno/features/learning_path/domain/models/learning_models.dart';

class CourseDetailsScreen extends ConsumerWidget {
  final String subjectId;
  final String courseId;

  const CourseDetailsScreen({super.key, required this.subjectId, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Course Topics', style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textDark),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            ref.read(audioManagerProvider).playClick();
            context.pop();
          },
        ),
      ),
      body: FutureBuilder<Subject?>(
        future: ref.read(learningRepositoryProvider).getSubjectById(subjectId),
        builder: (context, subjectSnapshot) {
          if (subjectSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue));
          }

          final subject = subjectSnapshot.data;
          if (subject == null) {
            return const Center(child: Text("Subject not found."));
          }

          return FutureBuilder<List<Topic>>(
            future: ref.read(learningRepositoryProvider).getTopicsForCourse(courseId),
            builder: (context, topicsSnapshot) {
              if (topicsSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue));
              }

              final topics = topicsSnapshot.data ?? [];

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ...topics.map((t) => _buildTopicCard(context, ref, t, subject)),
                  const SizedBox(height: 20),
                  _buildFinalAssessmentCard(context, ref, subject),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, WidgetRef ref, Topic topic, Subject subject) {
    return GestureDetector(
      onTap: () {
        ref.read(audioManagerProvider).playClick();
        context.push('/subject/${subject.id}/course/$courseId/topic/${topic.id}/lesson');
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
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: subject.themeColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${topic.orderIndex}', 
                  style: TextStyle(
                    color: subject.themeColor, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 20
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title, 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)
                  ),
                  const SizedBox(height: 4),
                  Text(
                    topic.description, 
                    style: const TextStyle(color: Colors.grey, fontSize: 13)
                  ),
                ],
              ),
            ),
            Icon(Icons.play_circle_fill, color: subject.themeColor, size: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalAssessmentCard(BuildContext context, WidgetRef ref, Subject subject) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.stars, color: Colors.amber, size: 60),
          const SizedBox(height: 12),
          const Text('Final Assessment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
          const SizedBox(height: 8),
          const Text('Complete all topics to unlock the final course quiz and earn your badge.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
               ref.read(audioManagerProvider).playFail();
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Topics not completed yet!')));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.grey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            child: const Text('Locked'),
          )
        ],
      ),
    );
  }
}
