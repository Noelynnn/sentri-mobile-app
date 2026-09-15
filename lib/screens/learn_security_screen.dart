import 'package:flutter/material.dart';

import '../data/security_lessons.dart';
import '../models/security_lesson.dart';
import '../services/learning_progress_service.dart';
import '../theme/app_colors.dart';
import '../widgets/security_topic_card.dart';
import 'security_lesson_screen.dart';

class LearnSecurityScreen extends StatefulWidget {
  const LearnSecurityScreen({super.key});

  @override
  State<LearnSecurityScreen> createState() => _LearnSecurityScreenState();
}

class _LearnSecurityScreenState extends State<LearnSecurityScreen> {
  final TextEditingController _searchController = TextEditingController();

  final LearningProgressService _progressService = LearningProgressService();

  String _searchQuery = '';

  Set<String> _savedLessons = {};
  Set<String> _completedLessons = {};
  bool _progressLoading = true;

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
      _progressLoading = false;
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
    final filteredLessons = _filterLessons(SecurityLessons.all);

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
            const SizedBox(height: 10),
            const Text(
              'Learn practical ways to protect yourself from '
              'scams, phishing, fraud, and other online threats.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 22),
            _buildLearningIntro(),
            const SizedBox(height: 20),
            _buildSearchField(),
            const SizedBox(height: 24),
            if (!_progressLoading) _buildProgressSummary(),
            if (!_progressLoading) const SizedBox(height: 24),
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
                      bottom: 24,
                    ),
                    child: _buildCategorySection(
                      context,
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

  Widget _buildLearningIntro() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.15),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.white,
            child: Icon(
              Icons.school_outlined,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learn in a few minutes',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Explore short lessons, safety tips, and trusted '
                  'resources you can use to build safer digital habits.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
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

  Widget _buildProgressSummary() {
    final total = SecurityLessons.all.length;
    final completed = _completedLessons.length.clamp(
      0,
      total,
    );

    final progress = total == 0 ? 0.0 : completed / total;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.school_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Your Learning Progress',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Text(
                '$completed/$total',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
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

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
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
          fontSize: 15,
        ),
        decoration: InputDecoration(
          icon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
          ),
          hintText: 'Search security lessons...',
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.75),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
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
          SizedBox(height: 12),
          Text(
            'No lessons found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 5),
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

  Widget _buildCategorySection(
    BuildContext context,
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
        const SizedBox(height: 12),
        ...lessons.map(
          (lesson) => Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
            ),
            child: _buildLessonCard(
              lesson,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLessonCard(
    SecurityLesson lesson,
  ) {
    final isSaved = _savedLessons.contains(
      lesson.title,
    );

    final isCompleted = _completedLessons.contains(
      lesson.title,
    );

    return Stack(
      children: [
        SecurityTopicCard(
          icon: lesson.icon,
          title: lesson.title,
          description: lesson.description,
          onTap: () => _openLesson(lesson),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Row(
            children: [
              if (isCompleted)
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.safeBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: AppColors.safe,
                  ),
                ),
              if (isCompleted && isSaved) const SizedBox(width: 6),
              if (isSaved)
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bookmark_rounded,
                    size: 17,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ],
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

  List<SecurityLesson> _filterLessons(
    List<SecurityLesson> lessons,
  ) {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return lessons;
    }

    return lessons.where((lesson) {
      return lesson.title.toLowerCase().contains(query) ||
          lesson.description.toLowerCase().contains(query) ||
          lesson.category.name.toLowerCase().contains(query);
    }).toList();
  }
}
