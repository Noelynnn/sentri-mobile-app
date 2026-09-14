import 'package:flutter/material.dart';

import '../services/security_activity_service.dart';
import '../theme/app_colors.dart';

class SecurityActivityScreen extends StatefulWidget {
  const SecurityActivityScreen({
    super.key,
  });

  @override
  State<SecurityActivityScreen> createState() => _SecurityActivityScreenState();
}

class _SecurityActivityScreenState extends State<SecurityActivityScreen> {
  final SecurityActivityService _activityService = SecurityActivityService();

  List<SecurityActivity> _activities = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadActivity();
  }

  Future<void> _loadActivity() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final activities = await _activityService.getActivity();

      if (!mounted) return;

      setState(() {
        _activities = activities;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Unable to load your security activity.';
        _isLoading = false;
      });
    }
  }

  String _activityTitle(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'scam_check':
        return 'Scam Check';

      case 'phishing_check':
        return 'Phishing Check';

      default:
        return 'Security Check';
    }
  }

  IconData _activityIcon(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'scam_check':
        return Icons.security_rounded;

      case 'phishing_check':
        return Icons.link_rounded;

      default:
        return Icons.shield_outlined;
    }
  }

  Color _riskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'highrisk':
        return AppColors.highRisk;

      case 'suspicious':
        return AppColors.suspicious;

      case 'safe':
      default:
        return AppColors.safe;
    }
  }

  Color _riskBackground(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'highrisk':
        return AppColors.highRiskBackground;

      case 'suspicious':
        return AppColors.suspiciousBackground;

      case 'safe':
      default:
        return AppColors.safeBackground;
    }
  }

  String _riskLabel(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'highrisk':
        return 'High Risk';

      case 'suspicious':
        return 'Suspicious';

      case 'safe':
      default:
        return 'Safe';
    }
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();

    return '${localDate.day.toString().padLeft(2, '0')}/'
        '${localDate.month.toString().padLeft(2, '0')}/'
        '${localDate.year}';
  }

  String _formatTime(DateTime date) {
    final localDate = date.toLocal();

    final hour = localDate.hour == 0
        ? 12
        : localDate.hour > 12
            ? localDate.hour - 12
            : localDate.hour;

    final minute = localDate.minute.toString().padLeft(2, '0');

    final period = localDate.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.insights_outlined,
              color: AppColors.primary,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Security Activity',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'See the scam and phishing checks that contribute to your Sentri security status.',
                  style: TextStyle(
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

  Widget _buildActivityCard(
    SecurityActivity activity,
  ) {
    final riskColor = _riskColor(activity.riskLevel);

    final riskBackground = _riskBackground(activity.riskLevel);

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: riskBackground,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              _activityIcon(
                activity.activityType,
              ),
              color: riskColor,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        _activityTitle(
                          activity.activityType,
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: riskBackground,
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: Text(
                        _riskLabel(
                          activity.riskLevel,
                        ),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: riskColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  '${_formatDate(activity.createdAt)} • '
                  '${_formatTime(activity.createdAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Risk score',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${activity.riskScore}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: riskColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (activity.riskScore / 100).clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: AppColors.background,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      riskColor,
                    ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 30,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.safeBackground,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.safe,
              size: 30,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'No security activity yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Run a scam or phishing check and your activity will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 110),
          const Icon(
            Icons.cloud_off_rounded,
            size: 52,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Couldn’t load activity',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check your connection and try again.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 22),
          Center(
            child: ElevatedButton(
              onPressed: _loadActivity,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ),
        ],
      );
    }

    if (_activities.isEmpty) {
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadActivity,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),
          children: [
            _buildIntroCard(),
            const SizedBox(height: 24),
            _buildEmptyState(),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadActivity,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          30,
        ),
        itemCount: _activities.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildIntroCard();
          }

          final activity = _activities[index - 1];

          return _buildActivityCard(
            activity,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Security Activity',
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
        child: _buildBody(),
      ),
    );
  }
}
