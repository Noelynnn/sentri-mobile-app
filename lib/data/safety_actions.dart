import 'package:flutter/material.dart';

import '../models/safety_action.dart';

class SafetyActions {
  SafetyActions._();

  static const List<String> interactionOptions = [
    'I just received it',
    'I clicked a link',
    'I shared information',
    'I sent money',
  ];

  static SafetyActionPlan getPlan({
    required String riskLevel,
    required String interaction,
    required String analysisType,
  }) {
    final normalizedRisk = riskLevel.toLowerCase().trim();
    final normalizedInteraction = interaction.toLowerCase().trim();
    final normalizedType = analysisType.toLowerCase().trim();

    if (normalizedInteraction == 'i clicked a link') {
      return _clickedLinkPlan(
        riskLevel: normalizedRisk,
        analysisType: normalizedType,
      );
    }

    if (normalizedInteraction == 'i shared information') {
      return _sharedInformationPlan(
        riskLevel: normalizedRisk,
        analysisType: normalizedType,
      );
    }

    if (normalizedInteraction == 'i sent money') {
      return _sentMoneyPlan(
        riskLevel: normalizedRisk,
      );
    }

    return _receivedMessagePlan(
      riskLevel: normalizedRisk,
      analysisType: normalizedType,
    );
  }

  static SafetyActionPlan _receivedMessagePlan({
    required String riskLevel,
    required String analysisType,
  }) {
    final bool isHighRisk = riskLevel == 'highrisk';
    final bool isSuspicious = riskLevel == 'suspicious';

    if (isHighRisk) {
      return SafetyActionPlan(
        title: 'Protect yourself now',
        summary: analysisType == 'phishing'
            ? 'This content shows strong signs of phishing. Avoid interacting with it and secure your accounts if necessary.'
            : 'This content shows strong signs of a scam. Do not continue the conversation, send money, or share personal information.',
        actions: [
          const SafetyAction(
            title: 'Do not click any links',
            description:
                'Avoid links, attachments, buttons, QR codes, or downloads contained in the message.',
            icon: Icons.link_off_rounded,
            important: true,
          ),
          const SafetyAction(
            title: 'Do not reply',
            description:
                'Do not confirm your phone number, account details, identity, or other personal information.',
            icon: Icons.reply_rounded,
          ),
          const SafetyAction(
            title: 'Do not send money',
            description:
                'Do not make payments, deposits, transfers, or mobile-money transactions requested by the sender.',
            icon: Icons.payments_outlined,
            important: true,
          ),
          const SafetyAction(
            title: 'Verify independently',
            description:
                'Contact the organization or person using a trusted phone number, website, or app instead of the details in the message.',
            icon: Icons.verified_user_outlined,
          ),
          const SafetyAction(
            title: 'Keep the evidence',
            description:
                'Save screenshots, phone numbers, usernames, links, transaction details, and other useful information.',
            icon: Icons.save_alt_rounded,
          ),
        ],
      );
    }

    if (isSuspicious) {
      return const SafetyActionPlan(
        title: 'Proceed carefully',
        summary:
            'Some warning signs were detected. Avoid taking action until you can verify the message independently.',
        actions: [
          SafetyAction(
            title: 'Pause before responding',
            description:
                'Do not rush because of urgency, threats, rewards, or pressure from the sender.',
            icon: Icons.pause_circle_outline_rounded,
            important: true,
          ),
          SafetyAction(
            title: 'Avoid suspicious links',
            description:
                'Do not open unfamiliar links or download unexpected files until they have been verified.',
            icon: Icons.link_off_rounded,
          ),
          SafetyAction(
            title: 'Verify the sender',
            description:
                'Use a trusted contact method or official website to confirm the request.',
            icon: Icons.person_search_outlined,
          ),
          SafetyAction(
            title: 'Protect your information',
            description:
                'Do not share passwords, PINs, OTPs, banking information, or unnecessary personal details.',
            icon: Icons.lock_outline_rounded,
          ),
          SafetyAction(
            title: 'Keep the evidence',
            description:
                'Save the suspicious message and related details in case further action is needed.',
            icon: Icons.save_alt_rounded,
          ),
        ],
      );
    }

    return const SafetyActionPlan(
      title: 'Stay aware',
      summary:
          'No major warning signs were identified in this check. Continue using normal digital safety habits.',
      actions: [
        SafetyAction(
          title: 'Verify unexpected requests',
          description:
              'Even if a message looks normal, verify unusual requests for money, credentials, or sensitive information.',
          icon: Icons.verified_outlined,
        ),
        SafetyAction(
          title: 'Keep accounts protected',
          description:
              'Use strong passwords and enable two-factor authentication where available.',
          icon: Icons.security_outlined,
        ),
        SafetyAction(
          title: 'Think before clicking',
          description:
              'Check links, senders, and context before opening unfamiliar content.',
          icon: Icons.touch_app_outlined,
        ),
        SafetyAction(
          title: 'Keep learning',
          description:
              'Use Sentri lessons to strengthen your ability to recognise digital threats.',
          icon: Icons.school_outlined,
        ),
      ],
    );
  }

  static SafetyActionPlan _clickedLinkPlan({
    required String riskLevel,
    required String analysisType,
  }) {
    final bool highRisk = riskLevel == 'highrisk';

    return SafetyActionPlan(
      title: highRisk
          ? 'Secure yourself after clicking'
          : 'Take precautions after clicking',
      summary: analysisType == 'phishing'
          ? 'Because you opened a potentially unsafe link, avoid entering credentials or sensitive information and review your account security.'
          : 'Because you opened a potentially unsafe link, stop interacting with the page and take precautions before doing anything else.',
      actions: [
        const SafetyAction(
          title: 'Close the page',
          description:
              'Close the suspicious website or message and do not continue interacting with it.',
          icon: Icons.close_rounded,
          important: true,
        ),
        const SafetyAction(
          title: 'Do not enter more information',
          description:
              'Do not provide passwords, PINs, OTPs, card details, or other personal information.',
          icon: Icons.password_rounded,
          important: true,
        ),
        const SafetyAction(
          title: 'Change exposed passwords',
          description:
              'If you entered a password, change it immediately and update any other account using the same password.',
          icon: Icons.lock_reset_rounded,
        ),
        const SafetyAction(
          title: 'Check your account',
          description:
              'Look for unfamiliar login activity, profile changes, transactions, or messages.',
          icon: Icons.manage_accounts_outlined,
        ),
        const SafetyAction(
          title: 'Keep the link and evidence',
          description:
              'Save the suspicious URL, screenshot, sender details, and any information you entered.',
          icon: Icons.save_alt_rounded,
        ),
      ],
    );
  }

  static SafetyActionPlan _sharedInformationPlan({
    required String riskLevel,
    required String analysisType,
  }) {
    return const SafetyActionPlan(
      title: 'Protect the information you shared',
      summary:
          'The right next step depends on what information was shared. Start by securing anything that could give someone access to your accounts or money.',
      actions: [
        SafetyAction(
          title: 'Change exposed passwords',
          description:
              'Change any password you shared and avoid reusing it on other accounts.',
          icon: Icons.lock_reset_rounded,
          important: true,
        ),
        SafetyAction(
          title: 'Secure your accounts',
          description:
              'Enable two-factor authentication and review active sessions where available.',
          icon: Icons.security_outlined,
        ),
        SafetyAction(
          title: 'Protect financial information',
          description:
              'If banking or mobile-money details were shared, monitor transactions and contact the relevant provider through an official channel.',
          icon: Icons.account_balance_outlined,
          important: true,
        ),
        SafetyAction(
          title: 'Watch for follow-up attempts',
          description:
              'Scammers may use the information you already shared to make later messages seem more convincing.',
          icon: Icons.visibility_outlined,
        ),
        SafetyAction(
          title: 'Preserve evidence',
          description:
              'Keep screenshots, messages, numbers, usernames, links, and other relevant details.',
          icon: Icons.save_alt_rounded,
        ),
      ],
    );
  }

  static SafetyActionPlan _sentMoneyPlan({
    required String riskLevel,
  }) {
    return const SafetyActionPlan(
      title: 'Act quickly after sending money',
      summary:
          'Preserve your transaction evidence and contact the relevant financial or mobile-money provider through an official channel as soon as possible.',
      actions: [
        SafetyAction(
          title: 'Do not send more money',
          description:
              'Do not make another payment because the sender promises a refund, release of funds, or another benefit.',
          icon: Icons.money_off_csred_outlined,
          important: true,
        ),
        SafetyAction(
          title: 'Save the transaction details',
          description:
              'Keep the transaction message, amount, date, reference number, recipient details, and screenshots.',
          icon: Icons.receipt_long_outlined,
          important: true,
        ),
        SafetyAction(
          title: 'Contact the provider',
          description:
              'Use an official customer-care number, app, or website to report the transaction and ask what recovery options are available.',
          icon: Icons.support_agent_outlined,
        ),
        SafetyAction(
          title: 'Secure affected accounts',
          description:
              'Change exposed passwords or PINs and enable additional security controls where possible.',
          icon: Icons.security_outlined,
        ),
        SafetyAction(
          title: 'Consider official reporting',
          description:
              'Use Sentri to preserve the incident details and proceed to the relevant official reporting channel.',
          icon: Icons.report_problem_outlined,
        ),
      ],
    );
  }
}
