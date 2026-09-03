import 'package:flutter/material.dart';

class SecurityLesson {
  final String title;
  final String description;
  final IconData icon;
  final List<String> sections;
  final List<String> tips;

  const SecurityLesson({
    required this.title,
    required this.description,
    required this.icon,
    required this.sections,
    required this.tips,
  });
}
