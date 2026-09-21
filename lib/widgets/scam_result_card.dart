import 'package:flutter/material.dart';

import '../models/risk_level.dart';
import '../models/analysis_result.dart';
import '../theme/app_colors.dart';

class ScamResultCard extends StatelessWidget {
  final AnalysisResult result;

  const ScamResultCard({
    super.key,
    required this.result,
  });

  Color get _riskColor {
    switch (result.riskLevel) {
      case RiskLevel.safe:
        return AppColors.safe;

      case RiskLevel.suspicious:
        return AppColors.suspicious;

      case RiskLevel.highRisk:
        return AppColors.highRisk;
    }
  }

  Color get _riskBackground {
    switch (result.riskLevel) {
      case RiskLevel.safe:
        return AppColors.safeBackground;

      case RiskLevel.suspicious:
        return AppColors.suspiciousBackground;

      case RiskLevel.highRisk:
        return AppColors.highRiskBackground;
    }
  }

  IconData get _riskIcon {
    switch (result.riskLevel) {
      case RiskLevel.safe:
        return Icons.verified_user_outlined;

      case RiskLevel.suspicious:
        return Icons.warning_amber_rounded;

      case RiskLevel.highRisk:
        return Icons.gpp_maybe_outlined;
    }
  }

  String get _riskLabel {
    switch (result.riskLevel) {
      case RiskLevel.safe:
        return 'Looks Safe';

      case RiskLevel.suspicious:
        return 'Suspicious';

      case RiskLevel.highRisk:
        return 'High Risk';
    }
  }

  String get _meaningText {
    switch (result.riskLevel) {
      case RiskLevel.safe:
        return 'Sentri did not identify strong scam indicators in this message.';

      case RiskLevel.suspicious:
        return 'Some characteristics of this message deserve extra caution.';

      case RiskLevel.highRisk:
        return 'This message contains several characteristics associated with high-risk scams.';
    }
  }

  double get _scoreValue {
    final score = result.riskScore.clamp(0, 100);

    return score / 100;
  }

  @override
  Widget build(BuildContext context) {
    final riskColor = _riskColor;
    final riskBackground = _riskBackground;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: riskColor.withOpacity(0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --------------------------------------------------
          // Result header
          // --------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: riskBackground,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  _riskIcon,
                  color: riskColor,
                  size: 27,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scam risk assessment',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _riskLabel,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: riskColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // --------------------------------------------------
          // Score
          // --------------------------------------------------
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Risk score',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${result.riskScore}/100',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: riskColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: _scoreValue,
                    minHeight: 8,
                    backgroundColor: AppColors.border.withOpacity(0.55),
                    color: riskColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --------------------------------------------------
          // Sentri's assessment
          // --------------------------------------------------
          const Text(
            'What Sentri found',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            result.message,
            style: const TextStyle(
              fontSize: 14,
              height: 1.55,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 18),

          // --------------------------------------------------
          // Why this result
          // --------------------------------------------------
          if (result.reasons.isNotEmpty) ...[
            const Text(
              'Why this result?',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 11),
            ...result.reasons.map(
              (reason) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(
                          top: 7,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          color: riskColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          reason,
                          style: const TextStyle(
                            fontSize: 13.5,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],

          const SizedBox(height: 8),

          // --------------------------------------------------
          // Meaning
          // --------------------------------------------------
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: riskBackground.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 19,
                  color: riskColor,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    _meaningText,
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
        ],
      ),
    );
  }
}
