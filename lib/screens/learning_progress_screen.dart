import 'package:flutter/material.dart';

import '../data/security_lessons.dart';
import '../models/security_lesson.dart';
import '../services/learning_progress_service.dart';
import '../theme/app_colors.dart';
import '../widgets/security_topic_card.dart';
import 'security_lesson_screen.dart';

class LearningProgressScreen extends StatefulWidget {
  const LearningProgressScreen({
    super.key,
  });

  @override
  State<LearningProgressScreen> createState() => _LearningProgressScreenState();
}

class _LearningProgressScreenState extends State<LearningProgressScreen> {
  final LearningProgressService _progressService = LearningProgressService();

  Set<String> _completedLessons = {};

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final completed = await _progressService.getCompletedLessons();

    if (!mounted) return;

    setState(() {
      _completedLessons = completed;
      _isLoading = false;
    });
  }

  Future<void> _openLesson(
    SecurityLesson lesson,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SecurityLessonScreen(
          lesson: lesson,
        ),
      ),
    );

    if (!mounted) return;

    await _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    final total = SecurityLessons.all.length;

    final completedLessons = SecurityLessons.all
        .where(
          (lesson) => _completedLessons.contains(
            lesson.title,
          ),
        )
        .toList();

    final incompleteLessons = SecurityLessons.all
        .where(
          (lesson) => !_completedLessons.contains(
            lesson.title,
          ),
        )
        .toList();

    final progress = total == 0 ? 0.0 : completedLessons.length / total;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Learning Progress',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _loadProgress,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  32,
                ),
                children: [
                  _buildProgressHeader(
                    total,
                    completedLessons.length,
                    progress,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  _buildCategoryProgress(),
                  if (incompleteLessons.isNotEmpty) ...[
                    const SizedBox(
                      height: 28,
                    ),
                    const Text(
                      'KEEP LEARNING',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SecurityTopicCard(
                      icon: incompleteLessons.first.icon,
                      title: incompleteLessons.first.title,
                      description:
                          'Continue your learning journey with this lesson.',
                      category: incompleteLessons.first.categoryTitle,
                      estimatedMinutes:
                          incompleteLessons.first.estimatedMinutes,
                      onTap: () => _openLesson(
                        incompleteLessons.first,
                      ),
                    ),
                  ],
                  if (completedLessons.isNotEmpty) ...[
                    const SizedBox(
                      height: 28,
                    ),
                    const Text(
                      'COMPLETED LESSONS',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ...completedLessons.map(
                      (lesson) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: SecurityTopicCard(
                          icon: lesson.icon,
                          title: lesson.title,
                          description: lesson.description,
                          category: lesson.categoryTitle,
                          estimatedMinutes: lesson.estimatedMinutes,
                          isCompleted: true,
                          onTap: () => _openLesson(
                            lesson,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildProgressHeader(
    int total,
    int completed,
    double progress,
  ) {
    String message;

    if (completed == 0) {
      message = 'Start your learning journey by completing your first lesson.';
    } else if (completed == total) {
      message = 'You have completed every lesson in the current library.';
    } else if (progress < 0.5) {
      message = 'Good start. Keep building your digital safety knowledge.';
    } else {
      message = 'You are making strong progress. Keep going.';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          24,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: AppColors.primary,
                  size: 27,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              const Expanded(
                child: Text(
                  'Your Learning Journey',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            children: [
              Text(
                '$completed of $total lessons completed',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              10,
            ),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.primaryLight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            message,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PROGRESS BY TOPIC',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ...SecurityLessonCategory.values.map(
          (category) {
            final lessons = SecurityLessons.all
                .where(
                  (lesson) => lesson.category == category,
                )
                .toList();

            final completed = lessons
                .where(
                  (lesson) => _completedLessons.contains(
                    lesson.title,
                  ),
                )
                .length;

            final progress = lessons.isEmpty ? 0.0 : completed / lessons.length;

            return Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: _buildCategoryCard(
                category,
                completed,
                lessons.length,
                progress,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    SecurityLessonCategory category,
    int completed,
    int total,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _categoryTitle(
                    category,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Text(
                '$completed/$total',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 9,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              8,
            ),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: AppColors.primaryLight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _categoryTitle(
    SecurityLessonCategory category,
  ) {
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
