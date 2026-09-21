import 'package:flutter/material.dart';

import '../data/security_lessons.dart';
import '../models/security_lesson.dart';
import '../services/learning_progress_service.dart';
import '../theme/app_colors.dart';
import '../widgets/security_topic_card.dart';
import 'security_lesson_screen.dart';

class LearnSecurityScreen extends StatefulWidget {
  const LearnSecurityScreen({
    super.key,
  });

  @override
  State<LearnSecurityScreen> createState() => _LearnSecurityScreenState();
}

class _LearnSecurityScreenState extends State<LearnSecurityScreen> {
  final TextEditingController _searchController = TextEditingController();

  final LearningProgressService _progressService = LearningProgressService();

  String _searchQuery = '';

  Set<String> _savedLessons = {};

  Set<String> _completedLessons = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    final saved = await _progressService.getSavedLessons();

    final completed = await _progressService.getCompletedLessons();

    if (!mounted) return;

    setState(() {
      _savedLessons = saved;
      _completedLessons = completed;
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

  SecurityLesson? get _continueLesson {
    for (final lesson in SecurityLessons.all) {
      if (!_completedLessons.contains(
        lesson.title,
      )) {
        return lesson;
      }
    }

    return null;
  }

  List<SecurityLesson> _filterLessons(
    List<SecurityLesson> lessons,
  ) {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return lessons;
    }

    return lessons.where(
      (lesson) {
        return lesson.title.toLowerCase().contains(query) ||
            lesson.description.toLowerCase().contains(query) ||
            lesson.categoryTitle.toLowerCase().contains(query);
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredLessons = _filterLessons(
      SecurityLessons.all,
    );

    final total = SecurityLessons.all.length;

    final completed = _completedLessons.length.clamp(
      0,
      total,
    );

    final progress = total == 0 ? 0.0 : completed / total;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Learn Security',
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            32,
          ),
          children: [
            const Text(
              'Stay Safe Online',
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                height: 1.15,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Build practical cybersecurity knowledge through lessons, real-world scenarios, and quick knowledge checks.',
              style: TextStyle(
                fontSize: 15.5,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _buildProgressCard(
              total,
              completed,
              progress,
            ),
            const SizedBox(
              height: 14,
            ),
            if (_continueLesson != null)
              _buildContinueCard(
                _continueLesson!,
              ),
            const SizedBox(
              height: 20,
            ),
            _buildSearchField(),
            const SizedBox(
              height: 24,
            ),
            if (filteredLessons.isEmpty) _buildNoResults(),
            if (filteredLessons.isNotEmpty)
              ...SecurityLessonCategory.values.map(
                (category) {
                  final categoryLessons = filteredLessons
                      .where(
                        (lesson) => lesson.category == category,
                      )
                      .toList();

                  if (categoryLessons.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 26,
                    ),
                    child: _buildCategorySection(
                      category,
                      categoryLessons,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(
    int total,
    int completed,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(21),
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
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your progress',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Keep building your digital safety knowledge.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$completed/$total',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 14,
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
        ],
      ),
    );
  }

  Widget _buildContinueCard(
    SecurityLesson lesson,
  ) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: () => _openLesson(lesson),
        borderRadius: BorderRadius.circular(21),
        child: Container(
          padding: const EdgeInsets.all(
            18,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              21,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: Icon(
                  lesson.icon,
                  color: AppColors.white,
                  size: 24,
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
                      'Continue learning',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      lesson.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      '${lesson.estimatedMinutes} min • ${lesson.categoryTitle}',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.white.withOpacity(
                          0.82,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 14.5,
        ),
        decoration: const InputDecoration(
          icon: Icon(
            Icons.search_rounded,
            color: AppColors.primary,
          ),
          hintText: 'Search security lessons...',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    SecurityLessonCategory category,
    List<SecurityLesson> lessons,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _categoryTitle(category),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          _categoryDescription(
            category,
          ),
          style: const TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(
          height: 12,
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
              isSaved: _savedLessons.contains(
                lesson.title,
              ),
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
    );
  }

  Widget _buildNoResults() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 42,
            color: AppColors.textSecondary,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'No lessons found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            'Try searching for another security topic.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppColors.textSecondary,
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

  String _categoryDescription(
    SecurityLessonCategory category,
  ) {
    switch (category) {
      case SecurityLessonCategory.scamsAndFraud:
        return 'Recognize common scams and protect your money and information.';

      case SecurityLessonCategory.accountAndDeviceSafety:
        return 'Strengthen the accounts and devices that hold your digital life.';

      case SecurityLessonCategory.onlineAwareness:
        return 'Build safer habits when communicating and browsing online.';
    }
  }
}
