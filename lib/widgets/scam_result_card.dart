import 'package:flutter/material.dart';

import '../models/analysis_result.dart';
import '../models/risk_level.dart';

class ScamResultCard extends StatelessWidget {
  final AnalysisResult result;

  const ScamResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final resultColor = _getResultColor(result.riskLevel);
    final resultIcon = _getResultIcon(result.riskLevel);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: resultColor.withOpacity(0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --------------------------------------------------
          // Header
          // --------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: resultColor.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  resultIcon,
                  size: 28,
                  color: resultColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Scam Analysis",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _riskLevelText(result.riskLevel),
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: resultColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // --------------------------------------------------
          // Risk score
          // --------------------------------------------------
          Text(
            "Risk score",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: result.riskScore / 100,
                    minHeight: 9,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      resultColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "${result.riskScore}/100",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: resultColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // --------------------------------------------------
          // Main message
          // --------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              result.message,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.grey.shade800,
              ),
            ),
          ),

          const SizedBox(height: 22),

          // --------------------------------------------------
          // Why we think so
          // --------------------------------------------------
          _buildSectionTitle(
            title: "Why we think so",
            icon: Icons.info_outline_rounded,
          ),

          const SizedBox(height: 10),

          ...result.reasons.map(
            (reason) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(
                      top: 6,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      color: resultColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      reason,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // --------------------------------------------------
          // Recommendation
          // --------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.indigo.shade100,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(
                  title: "What you should do",
                  icon: Icons.shield_outlined,
                ),
                const SizedBox(height: 8),
                Text(
                  result.recommendation,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.indigo.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 19,
          color: Colors.indigo.shade900,
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.indigo.shade900,
          ),
        ),
      ],
    );
  }

  String _riskLevelText(RiskLevel riskLevel) {
    switch (riskLevel) {
      case RiskLevel.safe:
        return "SAFE";

      case RiskLevel.suspicious:
        return "SUSPICIOUS";

      case RiskLevel.highRisk:
        return "HIGH RISK";
    }
  }

  IconData _getResultIcon(RiskLevel riskLevel) {
    switch (riskLevel) {
      case RiskLevel.safe:
        return Icons.check_circle_outline;

      case RiskLevel.suspicious:
        return Icons.warning_amber_rounded;

      case RiskLevel.highRisk:
        return Icons.dangerous_outlined;
    }
  }

  Color _getResultColor(RiskLevel riskLevel) {
    switch (riskLevel) {
      case RiskLevel.safe:
        return Colors.green;

      case RiskLevel.suspicious:
        return Colors.orange;

      case RiskLevel.highRisk:
        return Colors.red;
    }
  }
}
