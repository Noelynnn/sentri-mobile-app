class AnalysisResult {
  final String riskLevel;
  final String message;
  final String recommendation;

  const AnalysisResult({
    required this.riskLevel,
    required this.message,
    required this.recommendation,
  });
}
