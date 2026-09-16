import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SecurityStatusCard extends StatelessWidget {
  final String status;
  final String message;
  final int activityCount;
  final int recentSuspiciousCount;
  final int recentHighRiskCount;

  const SecurityStatusCard({
    super.key,
    required this.status,
    required this.message,
    required this.activityCount,
    required this.recentSuspiciousCount,
    required this.recentHighRiskCount,
  });

  Color get _statusColor {
    if (status == 'Stay Alert') {
      return AppColors.highRisk;
    }

    if (status == 'Be Cautious') {
      return AppColors.suspicious;
    }

    return AppColors.safe;
  }

  IconData get _statusIcon {
    if (status == 'Stay Alert') {
      return Icons.gpp_maybe_outlined;
    }

    if (status == 'Be Cautious') {
      return Icons.shield_outlined;
    }

    return Icons.verified_user_outlined;
  }

  String get _activitySummary {
    if (activityCount == 0) {
      return 'No security checks recorded yet.';
    }

    if (activityCount == 1) {
      return '1 security check recorded in the last 30 days.';
    }

    return '$activityCount security checks recorded in the last 30 days.';
  }

  Widget _buildStat({
    required String value,
    required String label,
    Color? color,
  }) {
    final statColor = color ?? AppColors.textDark;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: statColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: statusColor.withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _statusIcon,
                  color: statusColor,
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Security Status',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            _activitySummary,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.72),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _buildStat(
                  value: '$recentSuspiciousCount',
                  label: 'Suspicious',
                  color: recentSuspiciousCount > 0
                      ? AppColors.suspicious
                      : AppColors.textDark,
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: AppColors.border,
                ),
                const SizedBox(width: 14),
                _buildStat(
                  value: '$recentHighRiskCount',
                  label: 'High risk',
                  color: recentHighRiskCount > 0
                      ? AppColors.highRisk
                      : AppColors.textDark,
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: AppColors.border,
                ),
                const SizedBox(width: 14),
                _buildStat(
                  value: '7d',
                  label: 'Status window',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
