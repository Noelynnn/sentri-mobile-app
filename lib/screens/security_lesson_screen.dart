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

  final Map<int, int> _selectedAnswers = {};

  bool _quizSubmitted = false;

  int _quizScore = 0;

  bool get _quizPassed {
    final total = widget.lesson.quizQuestions.length;

    if (total == 0) {
      return true;
    }

    return _quizScore / total >= 0.75;
  }

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
    if (!_isCompleted && !_quizPassed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Complete the quick check first.',
          ),
        ),
      );

      return;
    }

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
        behavior: SnackBarBehavior.floating,
        content: Text(
          _isCompleted
              ? 'Lesson marked as completed.'
              : 'Lesson marked as incomplete.',
        ),
      ),
    );
  }

  void _submitQuiz() {
    final questions = widget.lesson.quizQuestions;

    if (_selectedAnswers.length != questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Answer every question before checking your result.',
          ),
        ),
      );

      return;
    }

    var score = 0;

    for (var i = 0; i < questions.length; i++) {
      if (_selectedAnswers[i] == questions[i].correctIndex) {
        score++;
      }
    }

    setState(() {
      _quizScore = score;
      _quizSubmitted = true;
    });
  }

  void _retryQuiz() {
    setState(() {
      _selectedAnswers.clear();
      _quizSubmitted = false;
      _quizScore = 0;
    });
  }

  void _selectAnswer(
    int questionIndex,
    int answerIndex,
  ) {
    if (_quizSubmitted) {
      return;
    }

    setState(() {
      _selectedAnswers[questionIndex] = answerIndex;
    });
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
            36,
          ),
          children: [
            _buildLessonHeader(lesson),
            const SizedBox(height: 20),
            if (!_isCompleted) _buildLessonProgressHint(),
            const SizedBox(height: 24),
            _buildObjectives(lesson),
            const SizedBox(height: 30),
            _buildSectionHeading(
              'Understanding the topic',
            ),
            const SizedBox(height: 12),
            ...lesson.sections.map(
              (section) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 14,
                ),
                child: _buildSectionCard(
                  section,
                ),
              ),
            ),
            const SizedBox(height: 14),
            _buildScenarioCard(lesson),
            const SizedBox(height: 28),
            _buildSectionHeading(
              'Warning signs',
            ),
            const SizedBox(height: 12),
            _buildBulletCard(
              lesson.warningSigns,
              icon: Icons.flag_outlined,
              iconColor: AppColors.suspicious,
              backgroundColor: AppColors.suspiciousBackground,
            ),
            const SizedBox(height: 28),
            _buildSectionHeading(
              'What to do',
            ),
            const SizedBox(height: 12),
            _buildNumberedCard(
              lesson.actions,
            ),
            const SizedBox(height: 28),
            _buildSectionHeading(
              'Common mistakes',
            ),
            const SizedBox(height: 12),
            _buildBulletCard(
              lesson.commonMistakes,
              icon: Icons.close_rounded,
              iconColor: AppColors.highRisk,
              backgroundColor: AppColors.highRiskBackground,
            ),
            const SizedBox(height: 28),
            _buildSectionHeading(
              'Safety tips',
            ),
            const SizedBox(height: 12),
            _buildBulletCard(
              lesson.tips,
              icon: Icons.check_circle_outline,
              iconColor: AppColors.safe,
              backgroundColor: AppColors.safeBackground,
            ),
            const SizedBox(height: 28),
            _buildQuizSection(lesson),
            const SizedBox(height: 30),
            _buildTakeawayCard(lesson),
            if (lesson.resources.isNotEmpty) ...[
              const SizedBox(height: 30),
              _buildResourcesSection(lesson),
            ],
            const SizedBox(height: 30),
            _buildCompletionSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonHeader(
    SecurityLesson lesson,
  ) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.15),
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
              fontSize: 14.5,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildHeaderTag(
                Icons.schedule_outlined,
                '${lesson.estimatedMinutes} min',
              ),
              _buildHeaderTag(
                Icons.category_outlined,
                lesson.categoryTitle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTag(
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.primary,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonProgressHint() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 19,
            color: AppColors.primary,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Work through the lesson, then take the quick check before marking it complete.',
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectives(
    SecurityLesson lesson,
  ) {
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
          const Text(
            'After this lesson, you should be able to:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          ...lesson.learningObjectives.map(
            (objective) => Padding(
              padding: const EdgeInsets.only(
                bottom: 9,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: AppColors.safe,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      objective,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.45,
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

  Widget _buildSectionHeading(
    String title,
  ) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildSectionCard(
    LessonSection section,
  ) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            section.body,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(
    SecurityLesson lesson,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Imagine this',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            lesson.scenario,
            style: const TextStyle(
              fontSize: 14,
              height: 1.55,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletCard(
    List<String> items, {
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
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
          ...items.asMap().entries.map(
            (entry) {
              final isLast = entry.key == items.length - 1;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: isLast ? 0 : 14,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        icon,
                        size: 16,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedCard(
    List<String> items,
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
          ...items.asMap().entries.map(
            (entry) {
              final isLast = entry.key == items.length - 1;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: isLast ? 0 : 15,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSection(
    SecurityLesson lesson,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.quiz_outlined,
                color: AppColors.primary,
                size: 23,
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Quick knowledge check',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          const Text(
            'Answer every question to see how well you understood the lesson.',
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          ...lesson.quizQuestions.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 18,
                  ),
                  child: _buildQuizQuestion(
                    entry.key,
                    entry.value,
                  ),
                ),
              ),
          if (!_quizSubmitted)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitQuiz,
                child: const Text(
                  'Check My Answers',
                ),
              ),
            )
          else
            _buildQuizResult(),
        ],
      ),
    );
  }

  Widget _buildQuizQuestion(
    int questionIndex,
    SecurityQuizQuestion question,
  ) {
    final selected = _selectedAnswers[questionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${questionIndex + 1}. ${question.question}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            height: 1.4,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 10),
        ...question.options.asMap().entries.map(
          (entry) {
            final answerIndex = entry.key;

            final isSelected = selected == answerIndex;

            final isCorrect =
                _quizSubmitted && answerIndex == question.correctIndex;

            final isIncorrect = _quizSubmitted && isSelected && !isCorrect;

            Color borderColor = AppColors.border;

            Color backgroundColor = AppColors.white;

            Color textColor = AppColors.textDark;

            if (isCorrect) {
              borderColor = AppColors.safe;
              backgroundColor = AppColors.safeBackground;
            } else if (isIncorrect) {
              borderColor = AppColors.highRisk;
              backgroundColor = AppColors.highRiskBackground;
            } else if (isSelected) {
              borderColor = AppColors.primary;
              backgroundColor = AppColors.primaryLight;
              textColor = AppColors.primary;
            }

            return Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
              ),
              child: InkWell(
                onTap: _quizSubmitted
                    ? null
                    : () {
                        _selectAnswer(
                          questionIndex,
                          answerIndex,
                        );
                      },
                borderRadius: BorderRadius.circular(
                  14,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(
                      14,
                    ),
                    border: Border.all(
                      color: borderColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 23,
                        height: 23,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected || isCorrect
                                ? textColor
                                : AppColors.border,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: isCorrect
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: AppColors.safe,
                              )
                            : isIncorrect
                                ? const Icon(
                                    Icons.close,
                                    size: 14,
                                    color: AppColors.highRisk,
                                  )
                                : isSelected
                                    ? Container(
                                        width: 9,
                                        height: 9,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        if (_quizSubmitted)
          Padding(
            padding: const EdgeInsets.only(
              top: 3,
            ),
            child: Container(
              padding: const EdgeInsets.all(
                11,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              child: Text(
                question.explanation,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuizResult() {
    final total = widget.lesson.quizQuestions.length;

    final passed = _quizPassed;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
            passed ? AppColors.safeBackground : AppColors.suspiciousBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (passed ? AppColors.safe : AppColors.suspicious)
              .withOpacity(0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                passed ? Icons.check_circle_rounded : Icons.refresh_rounded,
                color: passed ? AppColors.safe : AppColors.suspicious,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  passed ? 'Knowledge check passed' : 'Almost there',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: passed ? AppColors.safe : AppColors.suspicious,
                  ),
                ),
              ),
              Text(
                '$_quizScore/$total',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: passed ? AppColors.safe : AppColors.suspicious,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            passed
                ? 'Nice work. You can now mark this lesson as complete.'
                : 'Review the explanations above and try the knowledge check again.',
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
          if (!passed) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _retryQuiz,
              child: const Text(
                'Retry Knowledge Check',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTakeawayCard(
    SecurityLesson lesson,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_rounded,
            color: AppColors.primary,
            size: 23,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Key takeaway',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  lesson.takeaway,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
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

  Widget _buildResourcesSection(
    SecurityLesson lesson,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeading(
          'Learn More',
        ),
        const SizedBox(height: 7),
        const Text(
          'Explore additional trusted resources.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        ...lesson.resources.map(
          (resource) => _buildResourceCard(resource),
        ),
      ],
    );
  }

  Widget _buildResourceCard(
    LearningResource resource,
  ) {
    final isVideo = resource.type == LearningResourceType.video;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openResource(resource.url),
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(
                    13,
                  ),
                ),
                child: Icon(
                  isVideo ? Icons.play_circle_outline : Icons.article_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      resource.duration != null
                          ? '${resource.source} • ${resource.duration}'
                          : resource.source,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.open_in_new_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openResource(
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

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Unable to open this learning resource.',
          ),
        ),
      );
    }
  }

  Widget _buildCompletionSection() {
    if (_isCompleted) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.safeBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.safe.withOpacity(0.20),
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.safe,
              size: 40,
            ),
            const SizedBox(height: 9),
            const Text(
              'Lesson completed',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'This lesson has been added to your learning progress.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 13),
            OutlinedButton.icon(
              onPressed: _toggleCompleted,
              icon: const Icon(
                Icons.undo_rounded,
              ),
              label: const Text(
                'Mark as Incomplete',
              ),
            ),
          ],
        ),
      );
    }

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
          const Text(
            'Ready to finish?',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _quizPassed
                ? 'You completed the learning check. Mark this lesson as complete to add it to your progress.'
                : 'Complete the quick knowledge check before marking this lesson as complete.',
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _quizPassed ? _toggleCompleted : null,
              icon: const Icon(
                Icons.check_circle_outline,
              ),
              label: const Text(
                'Mark Lesson Complete',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
