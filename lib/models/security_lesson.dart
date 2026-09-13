import 'package:flutter/material.dart';

import 'learning_resource.dart';

enum SecurityLessonCategory {
  scamsAndFraud,
  accountAndDeviceSafety,
  onlineAwareness,
}

class SecurityLesson {
  final String title;
  final String description;
  final IconData icon;
  final SecurityLessonCategory category;
  final List<String> sections;
  final List<String> tips;
  final List<LearningResource> resources;

  const SecurityLesson({
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.sections,
    required this.tips,
    this.resources = const [],
  });
}
