import 'package:flutter/material.dart';

import '../models/analysis_result.dart';
import '../models/risk_level.dart';

class PhishingResultCard extends StatelessWidget {
  final AnalysisResult result;

  const PhishingResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final resultColor = _getResultColor(result.riskLevel);
    final resultIcon = _getResultIcon(result.riskLevel);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: resultColor.withOpacity(0.08),
        border: Border.all(
          color: resultColor.withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Result header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                resultIcon,
                size: 32,
                color: resultColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phishing Check Result",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _riskLevelText(result.riskLevel),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: resultColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Risk Score: ${result.riskScore}/100',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Main result message
          Text(
            result.message,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // Reasons
          Text(
            "Why we think so",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade900,
            ),
          ),

          const SizedBox(height: 10),

          ...result.reasons.map(
            (reason) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "• ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: resultColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      reason,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Recommendation
          Text(
            "What you should do",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade900,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            result.recommendation,
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
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
