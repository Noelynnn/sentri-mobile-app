import 'package:flutter/material.dart';

import '../data/security_lessons.dart';
import '../models/security_lesson.dart';
import '../services/learning_progress_service.dart';
import '../theme/app_colors.dart';
import '../widgets/security_topic_card.dart';
import 'security_lesson_screen.dart';

class SavedLessonsScreen extends StatefulWidget {
  const SavedLessonsScreen({
    super.key,
  });

  @override
  State<SavedLessonsScreen> createState() => _SavedLessonsScreenState();
}

class _SavedLessonsScreenState extends State<SavedLessonsScreen> {
  final LearningProgressService _progressService = LearningProgressService();

  Set<String> _savedLessons = {};

  Set<String> _completedLessons = {};

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedLessons();
  }

  Future<void> _loadSavedLessons() async {
    final saved = await _progressService.getSavedLessons();

    final completed = await _progressService.getCompletedLessons();

    if (!mounted) return;

    setState(() {
      _savedLessons = saved;
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

    await _loadSavedLessons();
  }

  @override
  Widget build(BuildContext context) {
    final lessons = SecurityLessons.all
        .where(
          (lesson) => _savedLessons.contains(
            lesson.title,
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Saved Lessons',
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
              onRefresh: _loadSavedLessons,
              child: lessons.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        12,
                        20,
                        32,
                      ),
                      children: [
                        _buildIntro(
                          lessons.length,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ...lessons.map(
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
                              isSaved: true,
                              isCompleted: _completedLessons.contains(
                                lesson.title,
                              ),
                              onTap: () => _openLesson(
                                lesson,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  Widget _buildIntro(
    int count,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                14,
              ),
            ),
            child: const Icon(
              Icons.bookmark_rounded,
              color: AppColors.primary,
              size: 23,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your saved library',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '$count ${count == 1 ? 'lesson' : 'lessons'} saved to revisit later.',
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        24,
        95,
        24,
        32,
      ),
      children: [
        Center(
          child: Container(
            width: 76,
            height: 76,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(
                24,
              ),
            ),
            child: const Icon(
              Icons.bookmark_border_rounded,
              color: AppColors.primary,
              size: 38,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'No saved lessons yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          'Found something useful but do not have time to finish it? Save the lesson and come back later.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
