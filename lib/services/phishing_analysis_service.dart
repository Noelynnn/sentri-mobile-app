import '../models/analysis_result.dart';
import '../models/risk_level.dart';

class PhishingAnalysisService {
  Future<AnalysisResult> analyze(String url) async {
    // Temporary delay to simulate an analysis request.
    await Future.delayed(
      const Duration(seconds: 2),
    );

    final normalizedUrl = url.trim().toLowerCase();

    if (normalizedUrl.contains("login") ||
        normalizedUrl.contains("verify") ||
        normalizedUrl.contains("account") ||
        normalizedUrl.contains("free") ||
        normalizedUrl.contains("claim")) {
      return const AnalysisResult(
        riskLevel: RiskLevel.highRisk,
        message:
            "This link contains patterns that may be associated with phishing attempts.",
        reasons: [
          "The URL contains language commonly used to create urgency or request verification.",
          "Phishing links may imitate legitimate login or account pages.",
          "The destination could not be independently verified.",
        ],
        recommendation:
            "Do not enter passwords, payment details, or other sensitive information until the website has been independently verified.",
      );
    }

    return const AnalysisResult(
      riskLevel: RiskLevel.suspicious,
      message:
          "This link does not show obvious phishing indicators from our basic check, but caution is still recommended.",
      reasons: [
        "A basic URL check cannot confirm whether a website is trustworthy.",
        "The destination should be verified before sensitive information is entered.",
      ],
      recommendation:
          "Verify the website address independently and avoid entering sensitive information if anything looks unusual.",
    );
  }
}
