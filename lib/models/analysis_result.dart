import 'risk_level.dart';

class AnalysisResult {
  final RiskLevel riskLevel;
  final String message;
  final List<String> reasons;
  final String recommendation;

  const AnalysisResult({
    required this.riskLevel,
    required this.message,
    required this.reasons,
    required this.recommendation,
  });
}
