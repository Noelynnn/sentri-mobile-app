import 'package:flutter/material.dart';

class SafetyAction {
  final String title;
  final String description;
  final IconData icon;
  final bool important;

  const SafetyAction({
    required this.title,
    required this.description,
    required this.icon,
    this.important = false,
  });
}

class SafetyActionPlan {
  final String title;
  final String summary;
  final List<SafetyAction> actions;

  const SafetyActionPlan({
    required this.title,
    required this.summary,
    required this.actions,
  });
}
