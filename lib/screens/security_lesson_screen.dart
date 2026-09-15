import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/learning_resource.dart';
import '../models/security_lesson.dart';
import '../services/learning_progress_service.dart';
import '../theme/app_colors.dart';

class SecurityLessonScreen extends StatefulWidget {
  final SecurityLesson lesson;

  const SecurityLessonScreen({
    super.key,
    required this.lesson,
  });

  @override
  State<SecurityLessonScreen> createState() => _SecurityLessonScreenState();
}

class _SecurityLessonScreenState extends State<SecurityLessonScreen> {
  final LearningProgressService _progressService = LearningProgressService();

  bool _isSaved = false;
  bool _isCompleted = false;
  bool _isLoadingProgress = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final saved = await _progressService.isLessonSaved(
      widget.lesson.title,
    );

    final completed = await _progressService.isLessonCompleted(
      widget.lesson.title,
    );

    if (!mounted) return;

    setState(() {
      _isSaved = saved;
      _isCompleted = completed;
      _isLoadingProgress = false;
    });
  }

  Future<void> _toggleSaved() async {
    await _progressService.toggleSavedLesson(
      widget.lesson.title,
    );

    if (!mounted) return;

    setState(() {
      _isSaved = !_isSaved;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        content: Text(
          _isSaved
              ? 'Lesson saved for later.'
              : 'Lesson removed from saved lessons.',
        ),
      ),
    );
  }

  Future<void> _toggleCompleted() async {
    if (_isCompleted) {
      await _progressService.unmarkLessonCompleted(
        widget.lesson.title,
      );
    } else {
      await _progressService.markLessonCompleted(
        widget.lesson.title,
      );
    }

    if (!mounted) return;

    setState(() {
      _isCompleted = !_isCompleted;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _isCompleted ? AppColors.safe : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        content: Text(
          _isCompleted
              ? 'Lesson marked as completed.'
              : 'Lesson marked as incomplete.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          lesson.title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          if (!_isLoadingProgress)
            IconButton(
              onPressed: _toggleSaved,
              tooltip: _isSaved ? 'Remove from saved lessons' : 'Save lesson',
              icon: Icon(
                _isSaved
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: AppColors.primary,
              ),
            ),
        ],
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
            _buildLessonHeader(lesson),
            const SizedBox(height: 20),
            _buildActions(),
            const SizedBox(height: 28),
            const Text(
              'What to know',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 14),
            ...lesson.sections.map(
              (section) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 16,
                ),
                child: Text(
                  section,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Safety Tips',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 14),
            _buildSafetyTips(lesson),
            if (lesson.resources.isNotEmpty) ...[
              const SizedBox(height: 28),
              const Text(
                'Learn More',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Explore additional trusted learning resources.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              ...lesson.resources.map(
                (resource) => _buildResourceCard(
                  context,
                  resource,
                ),
              ),
            ],
            if (_isCompleted) ...[
              const SizedBox(height: 28),
              _buildCompletedBanner(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLessonHeader(
    SecurityLesson lesson,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withOpacity(
            0.15,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              lesson.icon,
              size: 34,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            lesson.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            lesson.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isLoadingProgress ? null : _toggleSaved,
            icon: Icon(
              _isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            ),
            label: Text(
              _isSaved ? 'Saved' : 'Save Lesson',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(
                color: AppColors.border,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isLoadingProgress ? null : _toggleCompleted,
            icon: Icon(
              _isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.check_circle_outline,
            ),
            label: Text(
              _isCompleted ? 'Completed' : 'Mark Complete',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  _isCompleted ? AppColors.safe : AppColors.primary,
              side: BorderSide(
                color: _isCompleted ? AppColors.safe : AppColors.border,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyTips(
    SecurityLesson lesson,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          ...lesson.tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(
                bottom: 14,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 21,
                    color: AppColors.safe,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context,
    LearningResource resource,
  ) {
    final isVideo = resource.type == LearningResourceType.video;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openResource(
          context,
          resource.url,
        ),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(
              18,
            ),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
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
                child: Icon(
                  isVideo ? Icons.play_circle_outline : Icons.article_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resource.duration != null
                          ? '${resource.source} • ${resource.duration}'
                          : resource.source,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.open_in_new_rounded,
                size: 19,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.safeBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.safe.withOpacity(0.2),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppColors.safe,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'You completed this lesson.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openResource(
    BuildContext context,
    String url,
  ) async {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      return;
    }

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.highRisk,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Unable to open this learning resource.',
          ),
        ),
      );
    }
  }
}
