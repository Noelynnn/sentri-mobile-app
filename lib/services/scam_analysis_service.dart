import '../models/analysis_result.dart';
import '../models/risk_level.dart';

class ScamAnalysisService {
  Future<AnalysisResult> analyze({
    required String message,
    bool hasImage = false,
  }) async {
    // Temporary delay to simulate an analysis request.
    await Future.delayed(
      const Duration(seconds: 2),
    );

    final normalizedMessage = message.trim().toLowerCase();

    if (normalizedMessage.contains("congratulations") ||
        normalizedMessage.contains("urgent") ||
        normalizedMessage.contains("winner") ||
        normalizedMessage.contains("click") ||
        normalizedMessage.contains("prize")) {
      return const AnalysisResult(
        riskLevel: RiskLevel.highRisk,
        message:
            "This message contains several signs commonly associated with scams.",
        reasons: [
          "Creates a sense of urgency",
          "May encourage you to click a link",
          "Uses language commonly found in scam messages",
        ],
        recommendation:
            "Do not click links, send money, or share personal information.",
      );
    }

    if (hasImage && normalizedMessage.isEmpty) {
      return const AnalysisResult(
        riskLevel: RiskLevel.suspicious,
        message:
            "The screenshot has been submitted for review, but the current prototype cannot perform image analysis yet.",
        reasons: [
          "Image analysis will be connected to the detection service later.",
          "A screenshot alone cannot be reliably classified by the current mock analyzer.",
        ],
        recommendation:
            "Avoid interacting with the message until it has been properly verified.",
      );
    }

    return const AnalysisResult(
      riskLevel: RiskLevel.suspicious,
      message:
          "This message does not contain obvious scam indicators from our basic check, but caution is still recommended.",
      reasons: [
        "The message could not be fully verified.",
        "Unexpected messages should be treated cautiously.",
      ],
      recommendation:
          "Verify the sender independently before taking any action.",
    );
  }
}
