import 'package:flutter/material.dart';

import 'learning_resource.dart';

enum SecurityLessonCategory {
  scamsAndFraud,
  accountAndDeviceSafety,
  onlineAwareness,
}

class LessonSection {
  final String title;
  final String body;

  const LessonSection({
    required this.title,
    required this.body,
  });
}

class SecurityQuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const SecurityQuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class SecurityLesson {
  final String title;
  final String description;
  final IconData icon;
  final SecurityLessonCategory category;
  final int estimatedMinutes;

  final List<String> learningObjectives;

  final List<LessonSection> sections;

  final List<String> warningSigns;

  final String scenario;

  final List<String> actions;

  final List<String> commonMistakes;

  final List<String> tips;

  final String takeaway;

  final List<SecurityQuizQuestion> quizQuestions;

  final List<LearningResource> resources;

  const SecurityLesson({
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.estimatedMinutes,
    required this.learningObjectives,
    required this.sections,
    required this.warningSigns,
    required this.scenario,
    required this.actions,
    required this.commonMistakes,
    required this.tips,
    required this.takeaway,
    required this.quizQuestions,
    this.resources = const [],
  });

  String get categoryTitle {
    switch (category) {
      case SecurityLessonCategory.scamsAndFraud:
        return 'Scams & Fraud';

      case SecurityLessonCategory.accountAndDeviceSafety:
        return 'Account & Device Safety';

      case SecurityLessonCategory.onlineAwareness:
        return 'Online Awareness';
    }
  }
}
