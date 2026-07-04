import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/learning_path/data/repositories/learning_repository.dart';
import 'package:lerno/features/learning_path/domain/models/learning_models.dart';

class SubjectDetailsScreen extends ConsumerWidget {
  final String subjectId;

  const SubjectDetailsScreen({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Subject Courses',
            style: TextStyle(
                color: AppTheme.textDark, fontWeight: FontWeight.bold)),
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
            return const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryBlue));
          }

          final subject = subjectSnapshot.data;
          if (subject == null) {
            return const Center(child: Text("Subject not found."));
          }

          return FutureBuilder<List<Course>>(
            future: ref
                .read(learningRepositoryProvider)
                .getCoursesForSubject(subjectId),
            builder: (context, coursesSnapshot) {
              if (coursesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator(color: AppTheme.primaryBlue));
              }

              final courses = coursesSnapshot.data ?? [];

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildSubjectHero(subject),
                  const SizedBox(height: 30),
                  const Text('Courses',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textDark)),
                  const SizedBox(height: 15),
                  ...courses
                      .map((c) => _buildCourseCard(context, ref, c, subject)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSubjectHero(Subject subject) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: subject.themeColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: subject.themeColor.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          Icon(subject.icon, size: 80, color: Colors.white),
          const SizedBox(height: 16),
          Text(subject.name,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Text(subject.description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
      BuildContext context, WidgetRef ref, Course course, Subject subject) {
    return GestureDetector(
      onTap: () {
        ref.read(audioManagerProvider).playClick();
        context.push('/subject/${subject.id}/course/${course.id}');
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
                  color: subject.themeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                  child:
                      Icon(subject.icon, color: subject.themeColor, size: 40)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark)),
                  const SizedBox(height: 4),
                  Text(course.description,
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildTag(
                          '${course.topicCount} Topics', subject.themeColor),
                      const SizedBox(width: 8),
                      _buildTag(course.difficulty, Colors.grey),
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
