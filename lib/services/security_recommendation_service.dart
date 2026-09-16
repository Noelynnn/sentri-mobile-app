import '../data/security_lessons.dart';

import '../models/analysis_result.dart';
import '../models/security_lesson.dart';
import '../models/risk_level.dart';

class SecurityRecommendation {
  final SecurityLesson lesson;
  final String reason;

  const SecurityRecommendation({
    required this.lesson,
    required this.reason,
  });
}

class SecurityRecommendationService {
  const SecurityRecommendationService();

  SecurityRecommendation? forScam(
    AnalysisResult result, {
    String? sourceText,
  }) {
    if (result.riskLevel == RiskLevel.safe) {
      return null;
    }

    final text = (sourceText ?? '').toLowerCase();

    // More specific patterns come first.
    if (_containsAny(text, [
      'mpesa',
      'm-pesa',
      'm pesa',
      'mobile money',
      'safaricom',
      'airtel money',
      'send money',
      'cash transfer',
    ])) {
      return _recommend(
        'M-Pesa & Mobile Money Scams',
        'Learn how to recognize fake payment requests, urgent money demands, and mobile-money scams.',
      );
    }

    if (_containsAny(text, [
      'whatsapp',
      'wa.me',
      'whatsapp code',
      'verification code',
      'six digit code',
      '6 digit code',
      'two step verification',
    ])) {
      return _recommend(
        'WhatsApp Scams',
        'Learn how scammers use WhatsApp messages, fake verification requests, and account tricks.',
      );
    }

    if (_containsAny(text, [
      'job offer',
      'job opportunity',
      'employment',
      'hiring',
      'vacancy',
      'interview',
      'recruitment',
      'salary',
      'work from home',
    ])) {
      return _recommend(
        'Fake Job Offers',
        'Learn how to identify fake recruitment messages and suspicious job opportunities.',
      );
    }

    if (_containsAny(text, [
      'delivery',
      'parcel',
      'package',
      'order',
      'shopping',
      'refund',
      'seller',
      'buyer',
      'cart',
    ])) {
      return _recommend(
        'Online Shopping Scams',
        'Learn how fraudulent sellers, fake orders, and refund scams can trick online shoppers.',
      );
    }

    if (_containsAny(text, [
      'bank',
      'account suspended',
      'account blocked',
      'verify your account',
      'confirm your identity',
      'customer care',
      'support agent',
      'official account',
    ])) {
      return _recommend(
        'Impersonation Scams',
        'Learn how scammers pretend to be trusted companies, officials, or support agents.',
      );
    }

    if (_containsAny(text, [
      'sim replacement',
      'sim swap',
      'replace your sim',
      'new sim',
      'sim card',
    ])) {
      return _recommend(
        'SIM Swap Fraud',
        'Learn how criminals can target your phone number and what signs to watch for.',
      );
    }

    if (result.riskLevel == RiskLevel.highRisk) {
      return _recommend(
        'I Think I\'ve Been Scammed',
        'Learn what to do next when a message may be part of a scam.',
      );
    }

    return _recommend(
      'Online Scams',
      'Learn the warning signs that can help you spot suspicious scams earlier.',
    );
  }

  SecurityRecommendation? forPhishing(
    AnalysisResult result, {
    String? url,
  }) {
    if (result.riskLevel == RiskLevel.safe) {
      return null;
    }

    final link = (url ?? '').toLowerCase();

    if (_containsAny(link, [
      'wa.me',
      'whatsapp.com',
      'whatsapp',
    ])) {
      return _recommend(
        'WhatsApp Scams',
        'Learn how suspicious links and account tricks can be used to target WhatsApp users.',
      );
    }

    if (_containsAny(link, [
      'login',
      'signin',
      'sign-in',
      'verify',
      'verification',
      'account',
      'secure',
      'password',
      'bank',
    ])) {
      return _recommend(
        'Phishing Awareness',
        'Learn how attackers use fake login and verification pages to steal information.',
      );
    }

    return _recommend(
      'Phishing Awareness',
      'Learn how to recognize suspicious links and the techniques attackers use.',
    );
  }

  SecurityRecommendation _recommend(
    String lessonTitle,
    String reason,
  ) {
    final lesson = SecurityLessons.all.firstWhere(
      (lesson) => lesson.title == lessonTitle,
    );

    return SecurityRecommendation(
      lesson: lesson,
      reason: reason,
    );
  }

  bool _containsAny(
    String text,
    List<String> keywords,
  ) {
    return keywords.any(text.contains);
  }
}
