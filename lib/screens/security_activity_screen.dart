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

  SecurityActivitySummary? _summary;

  bool _isLoading = true;

  String? _errorMessage;

  String _selectedFilter = 'All';

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
      final results = await Future.wait([
        _activityService.getSummary(),
        _activityService.getActivity(),
      ]);

      if (!mounted) return;

      setState(() {
        _summary = results[0] as SecurityActivitySummary;
        _activities = results[1] as List<SecurityActivity>;
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

  List<SecurityActivity> get _filteredActivities {
    if (_selectedFilter == 'All') {
      return _activities;
    }

    return _activities.where((activity) {
      return _riskLabel(activity.riskLevel) == _selectedFilter;
    }).toList();
  }

  int get _safeCount {
    final activityCount = _summary?.activityCount ?? 0;
    final highRiskCount = _summary?.recentHighRiskCount ?? 0;
    final suspiciousCount = _summary?.recentSuspiciousCount ?? 0;

    final safeCount = activityCount - highRiskCount - suspiciousCount;

    return safeCount < 0 ? 0 : safeCount;
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

  String _activityDescription(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'scam_check':
        return 'Message or content analyzed for scam indicators.';

      case 'phishing_check':
        return 'Link analyzed for suspicious or phishing indicators.';

      default:
        return 'Security check completed in Sentri.';
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

  String _normalizeRiskLevel(String riskLevel) {
    final normalized = riskLevel
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');

    if (normalized == 'highrisk' ||
        normalized == 'high_risk' ||
        normalized == 'high.risk') {
      return 'highRisk';
    }

    if (normalized == 'suspicious') {
      return 'suspicious';
    }

    return 'safe';
  }

  Color _riskColor(String riskLevel) {
    switch (_normalizeRiskLevel(riskLevel)) {
      case 'highRisk':
        return AppColors.highRisk;

      case 'suspicious':
        return AppColors.suspicious;

      case 'safe':
      default:
        return AppColors.safe;
    }
  }

  Color _riskBackground(String riskLevel) {
    switch (_normalizeRiskLevel(riskLevel)) {
      case 'highRisk':
        return AppColors.highRiskBackground;

      case 'suspicious':
        return AppColors.suspiciousBackground;

      case 'safe':
      default:
        return AppColors.safeBackground;
    }
  }

  String _riskLabel(String riskLevel) {
    switch (_normalizeRiskLevel(riskLevel)) {
      case 'highRisk':
        return 'High Risk';

      case 'suspicious':
        return 'Suspicious';

      case 'safe':
      default:
        return 'Safe';
    }
  }

  String _statusTitle(String status) {
    final normalized = status.trim().toLowerCase();

    switch (normalized) {
      case 'stay alert':
        return 'Stay Alert';

      case 'be cautious':
        return 'Be Cautious';

      case 'no recent flags':
        return 'No Recent Flags';

      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    final normalized = status.trim().toLowerCase();

    switch (normalized) {
      case 'stay alert':
        return AppColors.highRisk;

      case 'be cautious':
        return AppColors.suspicious;

      case 'no recent flags':
      default:
        return AppColors.safe;
    }
  }

  Color _statusBackground(String status) {
    final normalized = status.trim().toLowerCase();

    switch (normalized) {
      case 'stay alert':
        return AppColors.highRiskBackground;

      case 'be cautious':
        return AppColors.suspiciousBackground;

      case 'no recent flags':
      default:
        return AppColors.safeBackground;
    }
  }

  IconData _statusIcon(String status) {
    final normalized = status.trim().toLowerCase();

    switch (normalized) {
      case 'stay alert':
        return Icons.warning_amber_rounded;

      case 'be cautious':
        return Icons.visibility_outlined;

      case 'no recent flags':
      default:
        return Icons.verified_user_outlined;
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

  Widget _buildStatusCard() {
    final summary = _summary;

    if (summary == null) {
      return const SizedBox.shrink();
    }

    final statusColor = _statusColor(
      summary.status,
    );

    final statusBackground = _statusBackground(
      summary.status,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: statusBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: statusColor.withOpacity(0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              _statusIcon(summary.status),
              color: statusColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent security status',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _statusTitle(summary.status),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  summary.message,
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

  Widget _buildStatCard({
    required String value,
    required String label,
    required Color color,
    required Color backgroundColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 9),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusCard(),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatCard(
              value: '${_summary?.activityCount ?? 0}',
              label: 'Total checks',
              color: AppColors.primary,
              backgroundColor: AppColors.primaryLight,
            ),
            const SizedBox(width: 10),
            _buildStatCard(
              value: '${_summary?.recentHighRiskCount ?? 0}',
              label: 'High risk',
              color: AppColors.highRisk,
              backgroundColor: AppColors.highRiskBackground,
            ),
            const SizedBox(width: 10),
            _buildStatCard(
              value: '${_summary?.recentSuspiciousCount ?? 0}',
              label: 'Suspicious',
              color: AppColors.suspicious,
              backgroundColor: AppColors.suspiciousBackground,
            ),
            const SizedBox(width: 10),
            _buildStatCard(
              value: '$_safeCount',
              label: 'Clear',
              color: AppColors.safe,
              backgroundColor: AppColors.safeBackground,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;

    Color color;

    switch (label) {
      case 'High Risk':
        color = AppColors.highRisk;
        break;

      case 'Suspicious':
        color = AppColors.suspicious;
        break;

      case 'Safe':
        color = AppColors.safe;
        break;

      case 'All':
      default:
        color = AppColors.primary;
    }

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedFilter = label;
        });
      },
      selectedColor: color.withOpacity(0.12),
      backgroundColor: AppColors.white,
      side: BorderSide(
        color: isSelected ? color.withOpacity(0.35) : AppColors.border,
      ),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: isSelected ? color : AppColors.textSecondary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
    );
  }

  Widget _buildActivityCard(
    SecurityActivity activity,
  ) {
    final riskColor = _riskColor(activity.riskLevel);

    final riskBackground = _riskBackground(activity.riskLevel);

    final riskScore = activity.riskScore.clamp(0, 100).toDouble();

    return Container(
      padding: const EdgeInsets.all(17),
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
                        const SizedBox(width: 8),
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
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: riskColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _activityDescription(
                        activity.activityType,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 7),
                Text(
                  '${_formatDate(activity.createdAt)} • '
                  '${_formatTime(activity.createdAt)}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              const Text(
                'Risk score',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '${activity.riskScore}/100',
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
              value: riskScore / 100,
              minHeight: 7,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation<Color>(
                riskColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasFilter = _selectedFilter != 'All';

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
              color:
                  hasFilter ? AppColors.primaryLight : AppColors.safeBackground,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              hasFilter ? Icons.filter_alt_off_rounded : Icons.shield_outlined,
              color: hasFilter ? AppColors.primary : AppColors.safe,
              size: 30,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            hasFilter
                ? 'No $_selectedFilter checks'
                : 'No security activity yet',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            hasFilter
                ? 'Try another filter to see more activity.'
                : 'Run a scam or phishing check and your activity will appear here.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final activities = _filteredActivities;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadActivity,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          32,
        ),
        children: [
          _buildSummary(),
          const SizedBox(height: 26),
          const Text(
            'ACTIVITY HISTORY',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All'),
                const SizedBox(width: 8),
                _buildFilterChip('High Risk'),
                const SizedBox(width: 8),
                _buildFilterChip('Suspicious'),
                const SizedBox(width: 8),
                _buildFilterChip('Safe'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (activities.isEmpty)
            _buildEmptyState()
          else
            ...activities.map(
              (activity) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: _buildActivityCard(
                  activity,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadActivity,
      child: ListView(
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
              child: const Text(
                'Try Again',
              ),
            ),
          ),
        ],
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
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              )
            : _errorMessage != null
                ? _buildErrorState()
                : _buildContent(),
      ),
    );
  }
}
