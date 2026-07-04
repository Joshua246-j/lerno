import 'package:flutter/material.dart';

class Subject {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color themeColor;
  final int courseCount;

  const Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.themeColor,
    required this.courseCount,
  });
}

class Course {
  final String id;
  final String subjectId;
  final String title;
  final String description;
  final String difficulty;
  final int topicCount;

  const Course({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.topicCount,
  });
}

class Topic {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final int orderIndex;
  
  const Topic({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.orderIndex,
  });
}

class Lesson {
  final String id;
  final String topicId;
  final String title;
  final String content; // The reading material
  final String keyPoints;
  final int estimatedMinutes;
  final int xpReward;

  const Lesson({
    required this.id,
    required this.topicId,
    required this.title,
    required this.content,
    required this.keyPoints,
    required this.estimatedMinutes,
    required this.xpReward,
  });
}

class QuizQuestion {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
}
