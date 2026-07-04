import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/features/learning_path/domain/models/learning_models.dart';

final learningRepositoryProvider = Provider((ref) => LearningRepository());

class LearningRepository {
  // Mock Subjects
  final List<Subject> _subjects = const [
    Subject(
        id: 'math',
        name: 'Mathematics',
        description: 'Numbers, logic, and problem solving.',
        icon: Icons.calculate,
        themeColor: Color(0xFF10B981),
        courseCount: 4),
    Subject(
        id: 'english',
        name: 'English',
        description: 'Grammar, vocabulary, and reading.',
        icon: Icons.abc,
        themeColor: Color(0xFFF59E0B),
        courseCount: 3),
    Subject(
        id: 'science',
        name: 'Science',
        description: 'Explore the world around you.',
        icon: Icons.science,
        themeColor: Color(0xFF8B5CF6),
        courseCount: 3),
    Subject(
        id: 'logic',
        name: 'Logic & Reasoning',
        description: 'Patterns, puzzles, and critical thinking.',
        icon: Icons.extension,
        themeColor: Color(0xFFEC4899),
        courseCount: 2),
  ];

  // Mock Courses
  final List<Course> _courses = const [
    Course(
        id: 'math_numbers',
        subjectId: 'math',
        title: 'Numbers & Counting',
        description: 'Learn the basics of counting from 1 to 100.',
        difficulty: 'Easy',
        topicCount: 3),
    Course(
        id: 'math_addition',
        subjectId: 'math',
        title: 'Addition Fundamentals',
        description: 'Combine numbers to find the total.',
        difficulty: 'Easy',
        topicCount: 4),
    Course(
        id: 'math_geometry',
        subjectId: 'math',
        title: 'Shapes & Geometry',
        description: 'Identify circles, squares, and triangles.',
        difficulty: 'Medium',
        topicCount: 3),
  ];

  // Mock Topics
  final List<Topic> _topics = const [
    Topic(
        id: 'topic_counting_1_20',
        courseId: 'math_numbers',
        title: 'Counting 1-20',
        description: 'Learn to count and recognize numbers up to 20.',
        orderIndex: 1),
    Topic(
        id: 'topic_counting_20_100',
        courseId: 'math_numbers',
        title: 'Counting to 100',
        description: 'Count by tens and ones to reach 100.',
        orderIndex: 2),
  ];

  // Mock Lessons
  final List<Lesson> _lessons = const [
    Lesson(
      id: 'lesson_1_20',
      topicId: 'topic_counting_1_20',
      title: 'Let\'s count to 20!',
      content:
          'Numbers are everywhere! We use them to count toys, fingers, and friends. Let\'s practice counting from 1 to 20. 1, 2, 3, 4, 5, 6, 7, 8, 9, 10! You have ten fingers. Now let\'s keep going: 11, 12, 13, 14, 15, 16, 17, 18, 19, 20!',
      keyPoints: '• 1 to 10 is the base.\n• 11 to 20 builds on the base.',
      estimatedMinutes: 3,
      xpReward: 50,
    ),
  ];

  // Mock Quizzes (Learning Mode)
  final Map<String, List<QuizQuestion>> _topicQuizzes = const {
    'topic_counting_1_20': [
      QuizQuestion(
        id: 'q1',
        questionText: 'What comes after 15?',
        options: ['14', '16', '20', '10'],
        correctOptionIndex: 1,
        explanation: '16 comes immediately after 15 when counting up.',
      ),
      QuizQuestion(
        id: 'q2',
        questionText: 'How many fingers do you have on two hands?',
        options: ['5', '20', '10', '12'],
        correctOptionIndex: 2,
        explanation: 'You have 5 fingers on each hand. 5 + 5 = 10.',
      ),
    ],
  };

  Future<List<Subject>> getSubjects() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _subjects;
  }

  Future<Subject?> getSubjectById(String id) async {
    return _subjects.where((s) => s.id == id).firstOrNull;
  }

  Future<List<Course>> getCoursesForSubject(String subjectId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _courses.where((c) => c.subjectId == subjectId).toList();
  }

  Future<List<Topic>> getTopicsForCourse(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var topics = _topics.where((t) => t.courseId == courseId).toList();
    topics.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return topics;
  }

  Future<Lesson?> getLessonForTopic(String topicId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _lessons.where((l) => l.topicId == topicId).firstOrNull;
  }

  Future<List<QuizQuestion>> getQuizForTopic(String topicId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _topicQuizzes[topicId] ?? [];
  }
}
